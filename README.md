 ```
  _____                             _       ___
 /  __ \                           | |     /   |
 | /  \/ ___  _ __  _ __   ___  ___| |_   / /| |
 | |    / _ \| '_ \| '_ \ / _ \/ __| __| / /_| |
 | \__/\ (_) | | | | | | |  __/ (__| |_  \___  |
  \____/\___/|_| |_|_| |_|\___|\___|\__|     |_/

```
### Connect 4

_by Chris Drit_

##### To Install + Run:

1. Clone this repo
1. `bundle install` _(`gem install bundler`)_
1. `bundle exec rails db:migrate`
1. `bundle exec rails s`

##### Run Tests?

1. `bundle exec rspec`

##### Play a game?

* This is responsive! Use your mobile :)
* Or... Open 2 separate browser windows side-by-side on your desktop.
* Make sure one is incognito and the other not. Otherwise expect Session Collision with all sorts of ugliness.
* Surf to `http://localhost:3000/` on both browser windows.
* If everything went well, you should see this:    

![alt text](https://raw.githubusercontent.com/ChrisDrit/connect-4/master/public/connect-4-screenshot-home.png "Connect 4 Home Page")


* Tap `start game` in one of the windows:

![alt_text](https://raw.githubusercontent.com/ChrisDrit/connect-4/master/public/connect-4-screenshot-waiting-for-player-2.png "Connect 4 Waiting...")

* Switch to the second window and tap `start game`.
* You are now in 2 player mode:

![alt_text](https://raw.githubusercontent.com/ChrisDrit/connect-4/master/public/connect-4-screenshot-game-grid.png "Connect 4 Game Grid")

* Tap a column to begin:

![alt_text](https://raw.githubusercontent.com/ChrisDrit/connect-4/master/public/connect-4-screenshot-plaing-game.png "Connect 4 Game Play")


##### Can anyone say responsive & mobile first?

![alt_text](https://raw.githubusercontent.com/ChrisDrit/connect-4/master/public/connect-4-screenshot-responsive.png "Connect 4 Responsive Game Grid")



