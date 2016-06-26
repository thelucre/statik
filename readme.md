## What's included?
1. Webpack builds and hot module reloading
2. SASS or Stylus loading
3. Coffee or JS loading
4. Classic PHP for rendering
5. YAML files for pseudo-DB content
6. Boilerplate to get running quick

### Setup
1. Run `npm install`
1. Run `composer install`
2. Rename `example.env` as `.env` (this will not be committed to the repo)
3. Edit the server details in `.env`
4. If you haven't, run `brew install ssh-copy-id`
5. If you haven't, copy your key to your remote servers using `ssh-copy-id user@serverip`

### Development
1. Set up a vhost of `yoursitename.dev` in MAMP pointed to the `/public` folder
2. Run `npm run watch` to kick off the hot module reload
3. Go to `yoursitename.dev`
4. Get to work.

### Deployment
1. Run `npm run deploy:staging` or `npm run deploy:production`. Only files in the `/assets` folder will be pushed to the server.

### Notes
- All content is parsed form YAML files within `/content` and set globally at your whimsy.
