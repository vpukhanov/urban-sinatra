# Urban Sinatra

Urban Dictionary browser made with [Sinatra framework](http://sinatrarb.com/) for learning purposes. Has single page navigation support (via terrible JS script). [Check it out on Render](https://urban-sinatra.onrender.com).

## How to run

    gem install bundler
    bundle install
    ruby app.rb

## Deployment

Master branch is automatically deployed to Heroku. If webpage hasn't been accessed for some time, it goes to sleep, so it could take some time to load. 

If you change a .css or .js file, you have to minify them manually before pushing. [This is being worked on](https://github.com/vpukhanov/urban-sinatra/issues/1).
