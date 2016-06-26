###
This file exports the webpack configuration object.  It is designed to be
imported into the app's webpack.config.coffee where it can be hacked if changes
are needed.
###

# Autoprefixer config
# https://github.com/ai/browserslist#queries
autoprefixerBrowsers = [
	'last 2 versions'
	'ie >= 9'
]

# Inspect how webpack is being run
minify = '-p' in process.argv # Compiling for production
hmr = '--hot' in process.argv # "Hot module replacement" / using webpack-dev-server

# Get the port number after the `--port` flag, if it exists, to serve HMR assets
port = 8080 # webpack dev server default
port = process.argv[process.argv.indexOf('--port')+1] if '--port' in process.argv

# Dependencies
_            = require 'lodash'
webpack      = require 'webpack'
autoprefixer = require 'autoprefixer'
moment       = require 'moment'
ExtractText  = require 'extract-text-webpack-plugin'
Notify       = require 'webpack-notifier'
# Clean        = require 'clean-webpack-plugin'
AssetsPlugin = require('assets-webpack-plugin')

# ##############################################################################
# Setup - General config
# ##############################################################################
config =

	# Generate source maps.  If using HMR, the sourcemap can be cheaper (less
	# CPU required) and should be inline.  Othwerise, generate external, full
	# sourcemaps.
	devtool: if hmr then 'inline-cheap-module-eval-source-map' else 'source-map'

	# Set the dir to look for entry files
	context: "#{process.cwd()}/assets"

	# Build one bundle for public site and one for admin. If additional front end
	# entry points are added, consider using CommonsChunkPlugin to move shared
	# dependencies out.
	entry:
		app: './boot.coffee'

	# Save the entry points to the public/dist directory.  And give any chunks
	# hashed names when minifying so they can be long term cashed.  The entry
	# JS doesn't need this as it gets unique URLs via PHP.
	output:
		path:          "#{process.cwd()}/public/dist"
		publicPath:    if hmr then 'http://localhost:'+port+'/dist/' else '/dist/'
		filename:      if minify then '[name].[hash:8].js' else '[name].js'
		chunkFilename: if minify then '[id].[hash:8].js' else '[id].js'

	# Setup properties that are set later (With less indentation)
	module: {}

	# Configure what shows up in the terminal output
	stats:
		children:     false # Hides the "extract-text-webpack-plugin" messages
		assets:       true
		colors:       true
		version:      false
		hash:         false
		timings:      true
		chunks:       false
		chunkModules: false

# # Modules that shouldn't get parsed for dependencies.	These will probably be
# # used in tandem with using aliases to point at built versions of the modules.
# config.module.noParse = [
#
# 	# Using a built version of pixijs for Decoy to fix issues where it errors on
# 	# trying to use node's `fs`.  Another solution could have been to set
# 	# node: { fs: 'empty' }
# 	# https://github.com/pixijs/pixi.js/issues/1854#issuecomment-156074530
# 	# https://github.com/pixijs/pixi.js/issues/2078#issuecomment-137297392
# 	/bin\/pixi\.js$/
#
# ]

# ##############################################################################
# Resolve - Where to find files
# ##############################################################################
config.resolve =

	# Allows JS modules to be found without using relative paths.  And for SCSS
	# modules to be resolved relative to the assets dir with a "~" prefix.
	root: config.context

	# Look for modules in the vendor directory as well as npm's directory.  The
	# vendor directory is used for third party modules that are committed to the
	# repo, like things that can't be installed via npm.  For example, Modernizr.
	modulesDirectories: ['node_modules']

	# Add coffee to the list of optional extensions
	extensions: ['', '.js', '.coffee', '.vue', '.styl']

	# Aliases for common libraries
	alias:
		velocity: 'velocity-animate'
		underscore: 'lodash'


# ##############################################################################
# Loaders - File transmogrifying
# ##############################################################################
config.module.loaders = [

	# Coffeescript #
	{ test: /\.coffee$/, loader: 'coffee-loader' }

	# Jade #
	# Jade-loader reutrns a function. Apply-loader executes the function so we
	# get a string back.
	{ test: /\.jade$/, loader: 'apply-loader!jade-loader' }

	# Haml #
	{ test: /\.haml$/, loader: 'haml-loader' }

	# HTML #
	{ test: /\.html$/, loader: 'html-loader' }

	# Images #
	# If files are smaller than the limit, becomes a data-url.  Otherwise,
	# copies the files into dist and returns the hashed URL.  Also runs imagemin.
	{
		test: /\.(png|gif|jpe?g|svg)$/
		loaders: [
			'url?limit=10000&name=img/[hash:8].[ext]'
			'img?progressive=true'
		]
	}

	# Fonts #
	# Not using the url-loader because serving multiple formats of a font would
	# mean inlining multiple formats that are unncessary for a given user.
	{
		test: /\.(eot|ttf|woff|woff2)$/
		loader: 'file-loader?name=fonts/[hash:8].[ext]'
	}

	# JSON #
	{ test: /\.json$/, loader: 'json-loader' }

	# CSS #
	{
		test: /\.css$/
		loader:
			if hmr
			then 'style-loader!css-loader?-autoprefixer'
			else ExtractText.extract 'css-loader?-autoprefixer'
	}

	# Stylus #
	# This also uses the ExtractText to generate a new CSS file, rather
	# than writing script tags to the DOM. This was required to get the CSS
	# sourcemaps exporting dependably. Note the "postcss" loader, that is
	# adding autoprefixer in.
	{
		test: /\.styl$/
		loader:
			if hmr
			then [
				'style-loader'
				'css-loader?sourceMap&-autoprefixer'
				'postcss-loader'
				'stylus-loader?sourceMap'
				# 'prepend-string-loader?string[]=@require "~definitions.styl";'
				].join('!')
			else ExtractText.extract [
				'css-loader?sourceMap'
				'postcss-loader'
				'stylus-loader?sourceMap'
				# 'prepend-string-loader?string[]=@require "~definitions.styl";'
			].join('!')
	}

	# Sass #
	# Including sass for Decoy support
	{
		test: /\.scss$/
		loader:
			if hmr
			then [
				'style-loader'
				'css-loader?sourceMap&-autoprefixer'
				'postcss-loader'
				'sass-loader?sourceMap'
				'import-glob-loader'
				].join('!')
			else ExtractText.extract [
				'css-loader?sourceMap'
				'postcss-loader'
				'sass-loader?sourceMap'
				'import-glob-loader'
			].join('!')
	}

	# jQuery #
	# This adds jquery to window globals so that it's useable from the console
	# but also so that it can be found by jQuery plugins, like Velocity. This
	# "test" syntax is used to find the file in node_modules, the "expose"
	# loader's examples ("require.resolve") don't work because node is looking
	# in the app node_modules.
	{ test: /jquery\.js$/, loader: 'expose-loader?$!expose?jQuery' }

	# jQuery plugins #
	# Make sure jQuery is loaded before Velocity
	{
		test: /(velocity|redactor\/redactor)\.js$/,
		loader: 'imports-loader?$=jquery'
	}

	# Vue #
	{ test: /\.vue$/, loader: 'vue-loader' }
]

# # Modernizr should be inlined into the layout file, so load it externally.
# # https://github.com/Modernizr/Modernizr/issues/1204#issuecomment-142143094
# # https://webpack.github.io/docs/library-and-externals.html#applications-and-externals
# config.externals =
# 	modernizr: 'Modernizr'


# ############################################################################
# Plugins - Register extra functionality
# ############################################################################
config.plugins = [

	# Required config for ExtractText to tell it what to name css files. Setting
	# "allChunks" so that CSS referenced in chunked code splits still show up
	# in here. Otherwise, we would need webpack to DOM insert the styles on
	# which doesn't play nice with sourcemaps.
	new ExtractText (if minify then '[name].[hash:8].css' else '[name].css'),
		allChunks: true

	# Show growl style notifications if not running via HMR. Wit HMR, page updates
	# automatically, so don't need to watch for compile be done.
	new Notify alwaysNotify: !hmr

	# Add some branding to all compiled JS files
	new webpack.BannerPlugin "📝 STATIK 💾 #{moment().format('M.D.YY')} 👍"

	# Empty the build directory whenever webpack starts up, but doesn't run on
	# watch updates.  Has the added benefit of clearing out the dist directory
	# when running the dev server.
	# new Clean ['public/dist'], { root: process.cwd() }

	# Output JSON config if the compiled files which is parsed by Laravel to
	# create script and link tags.
	new AssetsPlugin
		filename:    'manifest.json'
		path:        config.output.path
		prettyPrint: true

	# Provide common utils to all modules so they don't need to be expliclity
	# required.
	new webpack.ProvidePlugin
		$:         'jquery'
		jquery:    'jquery'
		_:         'lodash'
		Vue:       'vue'
		Modernizr: 'modernizr'
		Velocity:  'velocity'
]

# Minify only (`webpack -p`) plugins.
if minify then config.plugins = config.plugins.concat [

	# Turn off warnings during minifcation.  They aren't particularly helpfull.
	new webpack.optimize.UglifyJsPlugin compress: warnings: false

	# Make small ids
	new webpack.optimize.OccurenceOrderPlugin()

	# Try and remove duplicate modules
	new webpack.optimize.DedupePlugin()
]


# ##############################################################################
# Misc config - Mostly loader options
# ##############################################################################
_.assign config,

	# Configure autoprefixer using browserslist rules
	postcss: -> [ autoprefixer( browsers: autoprefixerBrowsers ) ]

	# Increase precision of math in SASS for Bootstrap
	# https://github.com/twbs/bootstrap-sass#sass-number-precision
	sassLoader: precision: 10

	# Customize the Vue loader
	vue:

		# Use the same autoprefixer rules
		autoprefixer: browsers: autoprefixerBrowsers

		loaders:

			# Support the css precompilers being explicitly defined.  This should be
			# identical to the webpack loaders EXCEPT with postcss removed, because
			# the Vue loader is doing that automatically.  Also, the prepending needs
			# to be explicity done here because there is no matching test on filetype.
			# https://github.com/hedefalk/atom-vue/issues/5
			stylus:
				if hmr
				then [
					'style-loader'
					'css-loader?sourceMap&-autoprefixer'
					'stylus-loader?sourceMap'
					'prepend-string-loader?string[]=@require "~definitions.styl";'
					].join('!')
				else ExtractText.extract [
					'css-loader?sourceMap&-autoprefixer'
					'stylus-loader?sourceMap'
					'prepend-string-loader?string[]=@require "~definitions.styl";'
				].join('!')

# ##############################################################################
# Export
# ##############################################################################
module.exports = config
