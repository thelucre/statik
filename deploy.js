require('dotenv').config();
var sys = require('sys')
var exec = require('child_process').exec;

// Pipe output to console
function puts(error, stdout, stderr) { sys.puts(stdout) }

// Parse server details from .env
function getServer(env) {
  return {
    user: process.env[env.toUpperCase()+'_USER'],
    host: process.env[env.toUpperCase()+'_HOST'],
    path: process.env[env.toUpperCase()+'_PATH']
  }
}

// Get the enviornment to deploy to (passed from package.json scripts)
var env = process.argv[2];

//Grab server connection details
var s = getServer(env);

// Run webpack compile and deploy to server 
exec ("webpack --config webpack.coffee && rsync -avz public/ "
  +s.user+"@"+s.host+":"+s.path, puts);
