# Cloud Assembly: Personal Blog Site

My old blog website has been neglected for many years, and its design has become quite embarrassing. I am now considering starting a new blog site, [Cloud Assembly](https://cloud-asm.com/).

Many of my current projects are still developed using the outdated versions of Ruby and Rails, some of which have already reached End-Of-Life (EOL). That is why, I have been eager to try Rails 7, and creating a new, simple blog site seems like the perfect opportunity to do so.

While I have traditionally used Bootstrap and yarn/npm for front-end development, this time, I'm excited to explore the possibilities offered by Tailwind CSS and Hotwire.

## Expectations
- It seems that [Hotwire Stimulus](https://stimulus.hotwired.dev/) simplifies the process of mapping data attributes to JavaScript-bundled controllers. I appreciate the concept of storing data and state directly in HTML rather than in JavaScript objects, as it can enhance maintainability and clarity.
- [Tailwind CSS](https://tailwindcss.com/) offers a comprehensive set of pre-built utility classes for styling. However, unlike Bootstrap, it doesn't include a base set of components such as buttons by default. I am curious to see how this impacts rapid prototyping. On one hand, the lack of pre-made components might slow down initial development. On the other hand, Tailwind's approach allows for more customisation and avoids the need to override default styles, which could ultimately lead to a more tailored and cohesive design.

# How to Post in the Blog ([cloud-asm.com](https://cloud-asm.com/))
Posting a blog involves four states:

### Draft
- You can save your content as a draft, meaning it will not be posted on the main page yet.
Note: Although draft articles are not publicised, their links can already be accessed by anyone.

### Published
- Published articles will be featured on the main page and may also be posted on social media (SNS).

### Scheduled Publish
- Scheduled publications are similar to drafts in that they are not yet featured to the public, and editing is still possible. If a scheduled post is modified, it will revert back to draft status.

### Revise
The contents of published articles can still be revised. While the original content has already been posted, revisions are possible. If you save a revision as a draft, it will not affect the currently displayed content.

# Getting started

This repository will show the step-by-step developments of my blog site, Cloud Assembly. The site will be an open platform where any users can post content. A personal page for each user will be included. If you would like to customise your own personal page template, feel free to create a Pull Request (PR). Please note that a Docker environment will not be set up anytime soon, so you'll need to prepare your own development environment in the meantime.

## Pre-requisite

- Ruby v3.1.6
- Postgres server v16.3

## Configuration (only once)

1.  Clone the project
```
  git clone [repository-url]
```
2.  Configure environment variables according to your local setup (planning to remove this inconvenience in future updates).
3.  Install the gems
```
  ./bin/bundle install
```
4.  Create the database
```
  ./bin/bundle exec rails db:create
```
5.  Apply the database migrations
```
  ./bin/bundle exec rails db:migrate
```

## Execution

1. Run `./bin/dev`


## Requirements for Pull Request (PR) Merge

- Code
- RSpec (not needed if design changes only)
- Review Approval

## Things To Do Before Submitting a PR

- Run and pass RuboCop
```
$ rubocop
```
- Execute and pass all test suites
```
$ bundle exec rspec spec
```


# Milestone
## User Management
   - [x] Registration
   - [x] Login
   - [ ] Profile Edit (\*)
   - [ ] Forgot Password (\*)
   - [ ] SNS Login (\*)

## Article Management
   - [x] Draft
   - [x] Publish

## Main Pages
   - [ ] Top
   - [ ] Article View
   - [ ] Articles by Tags (*)
   - [ ] Contact Us (*)
   - [ ] Privacy Policies, and other static pages (*)

## Image Management
   - [x] Upload Image
   - [x] Add Image to Article

## Tagging
   - [ ] Add Tagging to Articles

## Search
   - [ ] Implement Search Functionality

## Add-ons
   - [ ] Allow Users to Create Their Own Page Template
   - [ ] Show cookie consent


(*) These items will be developed later in the milestone.


# Limitations

Due to time and budget constraints, the following features will not be supported, or under consideration, at this time.

   - Images will be stored on the server instead of using AWS S3
   - RuboCop and RSpec checks will be performed manually instead of integrated with CircleCI
   - Dockerising/Podmanizing the development environment is under consideration
   - Functionalities involving email, such as "Forgot Password", will be excluded
   - Redis for caching
