# SaaS/Sinatra demos

## HTTP plumbing basics

* HTTP via Netcat. Show just returning simple text to display in browser (`nc -l 8000` and point browser at `localhost:8000/helloworld`)
  * Why localhost:8000?
  * Why `helloworld`? Where does this info appear in the request? What if we said `hello/you/world` instead of `helloworld`?
* But HTTP is more than this. Show inbound headers from browser, then outbound headers from a typical server; show content-type, length, etc.
  * `curl -i https://cs.berkeley.edu | more`
  * Server response includes headers and data; client request seems to include only headers. When might client request also include data? (Answer: when submitting a form)
* If HTTP error, show that headers indicate an error, but it's an app level error, not HTTP error: `curl -i https://cs.berkeley.edu/we_love_stanford`
* Contrast with a network-level error, eg `curl https://cs.stanfurd.edu`

## Sinatra "Hello World" demo with views and controller (directory `sinatra`)

* Sinatra hello-world demo: `bundle` then `rerun rackup` and point browser at `localhost:9292` (why port 9292?)  
  * Note which tasks the framework now handles: URL parsing, "packaging up" stuff to send back to browser with proper headers, etc.
  * Change one of the URL handlers to something like:
```ruby
get '/set/:something' do
  "Hello #{params[:something]}"
end
```
  * Now we see that Sinatra handles simple URL patterns and creates a nice hash for you called `params`.
  * Refer to the "SaaS stack" picture in Ch 2 lecture slides; identify Rack+Sinatra as the app server, WEBrick as the HTTP server
* Show MVC slide; Sinatra is a micro-framework that gives you Controller and Views, but doesn't say anything about Models.  In contrast,
Rails has strong opinions about what a model is.  
* To see a view, change body of one of the handlers to `erb :hello`, and edit `views/hello.erb`.  Show how interpolated variables are available
to the view, e.g. `<%= @something  %>`.  
  * When we set an instance variable in the controller method, of what class is it an instance variable? (Answer: of our app, which inherits from `Sinatra::Base`)
  * How is it that controller instance variables are available to the view?  (Answer: it violates OOP orthodoxy, but Sinatra designers 
  chose to do it because it makes it easy/pleasant for developers to handle common case of having controller set up some data to be 
  displayed in the view.)
  
## Cookies:  if we want to save info across requests (directory `sinatra-sessions`)

* Try setting instance variable in one controller method, then reading/displaying it from a different method. Why doesn't it work? (Answer: 
HTTP is stateless, and each time your app is hit a new instance of the app's class is created. So neither the protocol nor the app has a way to 
"persist" variables.)
* See cookie arriving from Google.com: `curl -D - http://www.google.com -o /dev/null`
* See outgoing cookie from Localhost: run `nc -l 8000`, point browser at `localhost:8000` and notice `Set-Cookie` header. It's browser's
job to store/remember these cookie values, and send the correct one to each site when you visit that site.  To verify, disable cookies
in your browser (method varies) and repeat this process; there should be no cookie header. The browser still has the cookie stored 
for `localhost`, but disabling cookies suppresses including the cookie in the header.
* How does Sinatra framework support cookies? Turn on Session gem in sinatra. Now we get an "automagical" hash that we can put
stuff in and it persists across requests!
* The session hash is a _leaky_ abstraction: it may not work the way you expect if you are totally oblivious to the implementation.  How could it go wrong?
  * User disables cookies - nothing you can do
  * User can "interpret" what's in cookie and tampers with it, e.g., trying to make it appear they're logged in as someone else. Solution: 
  Cookies are usually encrypted with a secret that only the server knows, which also makes them tamper-evident
  * Cookie length exceeds 4KiB, a limit set by HTTP specification - cookie may be mangled since it represents a serialized and possibly encrypted 
  object, so if truncated it's not reconstituted.  To solve, usually the server remembers most per-user state in a database, and the session 
  just holds a "handle" or some kind of ID to recall that state.
  

## RESTful thinking (directory `ttt`)

"Real example" of REST: show cs-coursequestionbank.herokuapp.com and note attention to users, questions, collections, etc.

Suppose we want to do a RESTful TicTacToe (noughts and crosses) game.

* What is the basic game state we must persist? (Board config; whose turn it is)
* How to represent it? (Simple: Linear array for game; indicator variable for turn)
* What RESTful actions do we want? Implies we can identify resources and operations on them, and whether each should be 
activated by an HTTP `GET`, `POST`, or other verb.
  * Board seems like a resource
  * Are players a resource? Not unless we want to do something with them , like remember win history.
  * Board: apply X move; apply O move; start new game (clear board).  Moves must check if square occupied, and ideally, if win.

We're developing this app entirely within the Sinatra controller. That's not a great idea. In general, the logic belongs in separate models,
with the controller just routing requests there.  In the Hangperson homework, you'll do it the right way: first create classes
and methods to represent the game's resources and gameplay operations, then "glue" these to the controller by mapping specific
game actions to routes (route = URI + HTTP method).

