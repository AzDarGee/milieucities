# Milieu

Copyright 2018 Milieu Cities && Project Collaborators

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Current [stage site](http://test.milieu.io/?page=0&latitude=43.544476130796994&longitude=-80.25039908384068&zoom=11.5) and [production site](https://cities.milieu.io)

### Installation & Usage
#### Start dev env without docker compose

1. Clone the repository to your local machine: `git clone https://github.com/Milieucities/m-server`.

2. Bundle the gemfile `bundle install`. Note you may have to install bundler `gem install bundler`.

3. Download and start up a postgressql. Best way to install it `brew install postgresql`
Ask for `.env` files ask for `database.yml` file
`.env` goes to the root folder
`database.yml` goes to `/config`
Accordingly to database.yml you'll need to create user mainly postgres
`psql`
`CREATE USER postgres;`
`ALTER USER postgres with SUPERUSER`;

4. Set up your `config/database.yml`
to configure with postgres and run `rake db:create db:migrate db:seed` and if you just want to reset database `rake db:reset` it should run all commands above with db:drop as first.
if you have any problems with database that doesn't exist, you should be able to see error in terminal of rails saying what DB name is missing
based on that create one by running: `CREATE DATABASE missingName`

5. (good to have) Download and start up a redis
with this being said -> sooon moving to Docker is must have

5. Install node packages `npm install`.

6. You're done! You have 2 options to run you development environment
1: is more encouraged to use to see what's going on
`npm start` in one tab of terminal, `rails s` in another one
2: these 2 commands below bundles everything from point above in  1 command
`foreman start` or `heroku local`

# on this point you should say Hooray, open the browser with whatever port your rails terminal says
Typically `localhost:3000` or if nothing works try `http://127.0.0.1:3000/`
and you good, man or lady !

#. SYNCING AND SEEDING DEV_SITES if you need to ->
Run the `rake sync_devsites` to get some devsites. Whenever you feel the devsites are enough,
run Ctrl+C(even more times)to stop the process.  Now you're ready to start developing!
for more syncing options run `rake -T`

### CSS and SCSS stylesheets
Application's stylesheets are located in`/app/assets/stylesheets`
if you open `application.scss` you'll see what's being imported to the whole app  in `base` folder you see base styles being used

### Start dev env with docker compose (Temporarily doesn't work)

1. Install Docker on Mac, Linux or Windows 10 (Windows 7, 8 installation is pretty complex)

2. Clone the repository to your local machine: `git clone https://github.com/Milieucities/m-server`.

3. Set up your `.env` and `config/database.yml`. See the .example file as the example.

4. Go to your local repository directory and build docker image: `docker-compose build`.

5. Start with `docker-compose up`.

6. Open another terminal to run `docker-compose run web rake db:create` & `docker-compose run web rake db:migrate` & `docker-compose run web rake db:seed`

### Deployment Steps

#### To deploy to staging

- Merge master into staging: `git push origin master:staging`
- Deploy with capistrano: `cap staging deploy`

#### To deploy to production

- Merge master into production: `git push origin master:production`
- SSH into production server: `ssh rails@cities.milieu.io`
- Log in as the root user: `su -`
- Go the to m-server directory: `cd /home/rails/m-server`
- Pull the production code: `git pull origin production`
- Migrate: `rake db:migrate`
- Compile the node code: `npm start`
- Compile all the assets: `rake assets:precompile`
- Restart unicorn: `service unicorn restart`

### Post Deployment Steps

#### Sync dev sites from CSV file
- SSH into remote server
- Run rake task to sync dev sites from CSV file: `rake sync_devsites_from_csv['example_filename.csv']`
- The file should be the most recent CSV file, in the `lib/fixtures` directory
