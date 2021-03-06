# Changelog

# 2
Complete Remade of the Application. Working Features:
* Registration / Authentication with password reset, email confirmation and change account functionality
* Topic Management
  * Topics can be open/closed. Normal users can not submit ideas, ratings or likes in closed topics.
  * Topics can be featured. Featured topics appear in the navigation bar directly as a link.
  * Topics can be published/unpublished. Unpublished topics are not visible by anonymous or normal users. Published but unfeatured topics still appear in the topic overview list (default homepage).
  * Topics have a short description, that is visible in the topic overview and on mouseover in the navigation bar
  * Topics have a long description, that is visible when a topic is opened
  * topics have a short title (menu) and a title (overview, topic pages)
  * Topic in Overview can be sorted and filtered in a smart table. Admins see more details. Clicking on a row opens the topic
* Ideas Management (topic page)
  * Ideas can be added/edited in open, published topics (admins can always post ideas)
  * When adding/editing an idea Admins can additionally set a fake rating and a fake user count. The real rating and real user count for ratings are aggregated.
  * The page is split in two halfs:
    * Idealist (left side)
    * On the left side a smart table showing a list of all ideas and avg. rating, # comments and when it was published. default sorted by date desc. Clicking on an idea opens the feedback panel on the right side.
  * Feedback Panel (right side)
  * a list of feedbacks/comments sorted by date.
  * Authenticated users (if topic is open) and admins can post feedback. Besides the feedback text, the name of the user and time is posted.
  * In open topics or if admin, users may like feedback (or remove their likes). this dynamically increases the like counter without need to reload the page. Also comments are added/removed dynamically.
  * Admins have the option to delete comments and set a fake like counter that gets added to the real like counter.
* User Management (Admins only)
  * Currently, users can be toggled to admins.
  * Users can be added/ Removed from Feedback condition. By default new users are randomly in Feedback condition.
* Convenience features such as automatic update of times (e.g. 3 minutes ago switches to 4 minutes ago after a minute).
* For many actions updates in the database are directly broadcasted to connected clients, causing their user interfaces to update (like in a chat). More functionality will be extended to this behavior.
* Usage of turbolinks that prevents full page reloads when links are followed and instead only replace the body through an ajax request resulting in much website faster performance. In general, I went wild with a lot of things I have learned in the last months. :)

## 2.1
* Added automated Prettier Codestyle for JS and CSS
* If new ideas are posted in a topic that is not the currently active topic, a badge appears that indicates the number of new ideas in that topic. resets when topic is opened.
* My-Rating is now preserved in view when navigating through ideas / on page load.
* On idea submission, server will automatically post a response comment from a random feedback user (after 30 seconds) that can only be seen by the posting user
* Improved Admin Users page
* Added a few test users with feedback condition
* ideas are now always sorted with newest one first descending
* Fixed several bugs
* automatic feedback now only visible to the user who posted the idea
* Admin Users Table is now fully responsive with sticky header and removed pagination
* Ideas Table now fully responsive with sticky header and removed pagination
* Cleaned up Ideas Panel Header
* Topic Desc, Shortdesc, Idea Desc and Comment Text can now be indefiniately long (bug that prevented e.g. changing topics and adding images)
* When editing topics you can now make use of 2 styling options "Image Left" and "Image Right" which automatically floats the image in the text
* Own ideas (if normal user) or non-admin ideas (if admin) are now displayed cursive in idealist to better identify them among pregenerated ideas.
* Isolation established: Ideas and comments have now a flag "public". If it is true the idea/comment is visible to all users. Non-public ideas can still be viewed by admins. By default contributions from admins are public and contributions from normal users are non-public.
* Connected to Google Analytics for user tracking


## 2.2
* Separated authentication for experiment users from admins, simpler account creation using only name and passcode now possible
* New system to avoid javascript and utilize commanders
* Experiment users can finish the experiment gracefully after a predefined amount of time.
* New, simplified rating system
* Functionality to directly edit content in page where needed (admins and partially normal users)
* Admins can now toggle topic flags directly in topic overview
* Admins can now filter users by their condition in the user list
* Moved Edit Topic link (for admins) to topic list
* Removed Delete Topic link as it poses a risk to data loss and topics can simply be hidden
* Users can no longer rate their own ideas and like their own comments
* Author names in comments from admins are now highlighted
* Instructions on first page included
* after completing experiment users are redirected to a thank you page
* Removed unnecessary social login buttons
* Removed link to register a normal account (although still possible)
* Removed option to open/close topics as hiding/showing topics already includes this feature for experiment users
* Removed unnecessary sorting/filtering features in user list
* Comments now ordered by date (ASC)
* Ideas now ordered by date (DESC)
* Form fields automaticaly size themselves if the content becomes larger (available when posting comments or editing ideas)
* Users that gracefully complete the experiment will be flaged as completed to separate them later from unfinished users
* fixed feedback loop (will go to next feedback now and so on until 10th feedback, then restart loop)
* fixed missing like count badge when being the first one to like a comment with no previous fake likes
* removed unnessesary javascript and css code
* updated all NPM and mix packages to latest versions
* replaced brunch with webpack (phoenix 1.4 upgrade)
* reduced pool size (to 5 connections) to lessen memory usage

## 2.3
* fixed port number in email links
* removed login via facebook or google placeholders
* separated participants from users in admin list view
* removed distinction between admin and peer users. both have condition = 0 now
* removed topic short-desc, topic short-title and visibility
* removed ability to delete topics, ideas and comments
* allows for eight conditions now
* switched from binary ids to int ids for better performance
* removed default registration, unlock, active and confirmation mechanics (unnecessary)
* by default: switched from client and server to serverside-only form validation. De-validation on input change happens now globally.
* exeriment minTime, google analytics tracking code, and survey codes retrieved from config instead of hard-coded
* improved performance of timer and switched to timeago display to avoid displaying seconds on higher minutes
* improved design of idea / comment layout
* ideas now sorted with newest one first
* comments now sorted with oldest on top
* passcode and default experiment user password removed from version tracking, now loaded through a system variable
* to test a specific condition you can now start the experiment, naming the user:  *test_x* where x is one of [ 1,2,3,4,5,6,7,8 ]
* removed testusers in seeds file, as they can now be created dynamically
* participants can no longer access topics they are not meant to see
* topics can no longer be directly edited via the topic overview page
* only one topic can be featured at a time now, main navbar item leads to featured topic
* comments and idea posted time now looks relative to start of experiment (for experiment users)
* improved rating mechanism: shows now own rating in separated space (blue star). If not rated yet, it shows a Rate tag for more intuitive handling. Users can now also remove their rating from an idea.
* fully finished delayed automated idea / comment / like / rating posting for specific conditions
* bot-to-user comments now do not persist in the database but can now be liked
* incorporated database changes from template
* submitting feedback, rating/unrating, like/unlike now via phoenix form instead of drab
* new mechanic so page will scroll to last position after submitting feedback
* no longer possible to edit ideas or update fake likes
* removed drab dependency

## 2.4
* removed coherence and scrivenier dependencies
* separated credentials from users
* experiment and peer users can no longer login
* passcode is now checked against a hash just like a real password
* when user exits the experiment compeleted will now be saved as a timestamp rather than a boolean (so we see how long they stayed in the sim)
* more intelligent query to load pregenerated ideas / comments
* liking, unlikeing and posting comments now done via channel and socket
* delayed post scheduling now done on server and communicated via channel
* fixed a bug that caused the deletion of other users's likes on liking a comment
* submitting new ideas via channel / socket instead of form now
* removed rating header for user ideas as they cannot be rated anyways
* optimized column mansion layout

### 2.4.1
* fixed: refreshing browser does not mess up bot-to-user comments anymore
* fixed: bot-to-user comments are now inserted at the correct place with the correct time
* fixed: bot-to-idea comments are now scheduled with the correct value
* fixed: refreshing while bot-to-user comment was still in the future caused the same feedback to appear twice
* increased possible text length of a comment from 200 to 500 characterrs
* ratings will now be displayed rounded to only one (instead of 2) digits behind decimal
* restored: delayed automated likes and ratings from bot

### 2.4.2
* improved flash message code
* metatag "user_token" now only appended when needed
* users can no longer prematurily finish experiment by clicking on timer
* improved logout mechanism

### 2.4.3
  * only version fixing

### 2.4.4
* fixed scheduled bot ideas:
  * now inserted at the beginning of the list, not at last position
  * Timeago is added only for the current element, instead of refreshing all
  * corrected countdown, when not yet published

### 2.4.5
* version of application can now be inspected in a meta tag
* support for javascript debugging created. Console will now tell (in dev mode):
  * How many seconds ago experiment was started, how long it will still take, and in which condition the user is in
  * once the timer runs out it will display an approriate message
  * all scheduled events and the number of seconds left until they are getting displayed
* fixed wrong class that prevented bot generated ideas from appearing
* fixed wrong selector that prevented comment submission
* fixed: after sucessful comment submission the text is now deleted and error messages discarded

## 2.5
* redesigned navbar to better fit USF colors, also added usf logo
* when logged in as admin participants few now shows how long users participated
* when logged in as admin, user and participants view now shows user ids

## 2.6
* implemented css loader in topic show view that hides when channel is ready and enables when communication to server is interrupted or not yet loaded.
* delayed likes are now added via channel event instead of javascript timer
* delayed likes that should have already been added are added at page load
* delayed likes are now configured in config file, instead of being hardcoded
* split up like and unlike into separate functions
* client javascript for like handling optimized
* depreciated passcode and survey code and replaced it with UID (USF ID). A uid can only once be used for the experiment
* removed completed_at field in user table as updated_at can be used for same purpose
* added completed (boolean) field that indicates graceful completion
* survey link now configurable in config and set to qualtrics
* improved configuration and put experiment settings in its own file
* added config setting: "allow_multiple_submissions?"
* users that abort the experiment can now still complete the survey
* before starting experiment users now have to agree to the terms
* improved the user changesets and added documentation

### 2.6.1
* Posting Ideas and Comments, Rating, Liking and Unliking now done again via form submission
* HTML5 validation tags are now automatically determined and added
* The time when a comment was liked is now also stored in database
* Topic is now always put into conn. If no topic is published, experiment registration will be disabled.
* added a reload mechansim that is more robust and auto-updates the page if no idea or comment is
currently being written. Preserves scroll position and does not flicker on reload.
* added plural support for rating / ratings
* if an idea currently does not have your rating and can be rated, the user-star is greyed out instead of blue.
* removed spinner and socket/channel system
* fixed some timing issues in condition 7 and 8
* gzip static resources for faster page load (now > 400 msec including all assets)
* page will now correctly reload when a new bot-comment has been published
* bot-ratings are now properly implemented



