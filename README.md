# Travel Diary app
## tl;dr
- Ruby on Rails backend and React frontend, both hosted on Heroku
- Front:
  - https://travel-diary.herokuapp.com
  - Gitgub repo: <a href='https://github.com/mat-jar/travel_diary_front'>travel_diary_front</a>
  - React: class and function components, useState, useEffect, conditional render, axios, runtimeEnv, bootstrap, react-bootstrap, font-awesome,  custom css, react-toastify, confirmation pop-up (react-bootstrap Modal), OAuth (react-google-login, gapi), localStorage, backend authorisation with request headers
- API:
  - https://travel-diary-api.herokuapp.com
  - Gitgub repo: <a href='https://github.com/mat-jar/travel_diary_api'>travel_diary_api</a>
  - RoR: api, OAuth (Google), Devise, devise_token_auth, service objects, query objects, httparty, PostgreSQL, Rspec (request tests), external API integration

## About
Travel Diary is a demonstration app meant to summarize some of my RoR and React skills as well as investigate OAuth login with Google. It allows users to create their own diary with travel experiences.  <br />
The functionality includes logging with Google credentials ang managing entries (creating, updating, deleting and listing).  <br />
While creating a new entry the current weather is automatically fetched from external API (<a href='https://www.visualcrossing.com'>https://www.visualcrossing.com</a>).

## Backend Details
The app consists of RoR backend and React frontend working separately, communicating via http requests. <br />
RoR backend main features:
-	OAuth + Devise
-	Scaffold for Entry
