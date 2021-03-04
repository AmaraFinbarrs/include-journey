<p align="center">
  <img src="logo-header-svg.jpg">
</p>

<p align="center">
  <a href="#introduction">Introduction & Motivation</a> •
  <a href="#tech-stack-&-requirements">Tech Stack & Requirements</a> •
  <a href="#local-installation">Local Installation</a> •
    <a href="#credit-and-license">Credit and License</a> •
  <br>
</p>


## Introduction

This project is a web application for Include Uk. The application is a journey tracker allowing
users to track their wellbeing journey. The features includes:
* Journaling + Sharing with Staff
* Visual analytics to track progress and wellbeing
* Self assesments
 

---

## Tech Stack & Requirements

The core technologies used for this project are:

* Ruby (2.7.2) (we recommend using rbenv for managing Ruby versions)
* Rails (6.1.3)
* Webpacker (5.0)
* Pg (1.1)
* Puma (5.0)
* Bootstrap (5.0.0.beta2)

---
## Local Installation
Follow these instuctions for local installation:

### Install dependencies
<details>
<summary>Some additional dependency steps might include:</summary>

#### Postgres

```zsh
sudo apt install postgresql postgresql-contrib`
sudo apt install libpq-dev
```
Setup postgres local db

#### Node

```zsh
sudo apt install nodejs
sudo apt install npm
sudo npm install -g npm@latest
sudo npm install --global yarn
```
</details>

Install Gems

`bundle`

Install Webpack

`rails webpacker:install`

Create the database and run migrations:

```zsh
rails db:create
rails db:migrate
rails db:seed
```

### Run the application

`rails s`

You should now be able to view the main web page at

``http://localhost:3000``

### Other Potential Fixes


You might be asked to override your local webpacker environment to work

```javascript
config/webpack/environment.js
```

---


## Credits and license
[MIT License](https://github.com/Legal-Innovation-Lab-Wales/expertise-directory/blob/add-license-1/LICENSE)

[Legal Innovation Lab Wales](https://legaltech.wales/)

---
## TODO Sections:
* How to run the test suite
* Services - 
job queues, cache servers, search engines, etc.

---

## Before Initial Commit

```zsh
rbenv local 2.7.2

rails new include-journey -d=postgresql
```

update .gitignore

update gem file with devise, sassc, faker, rspec, factory_bot_rails
```zsh
bundle
rails g devise:install
````
Following this guide:

https://github.com/heartcombo/devise/wiki/How-to-Setup-Multiple-Devise-User-Models
 ```zsh
rails g devise staff
rails g devise user
```
Update routes, generate views, generate controllers, finish multi-user-model guide

 ```zsh
 rails g model Note content:text visible_to_user:boolean team_member:belongs_to user:references 

 rails g scaffold_controller Note 

 rails g model CrisisType type:string team_member:belongs_to 

 rails g model CrisisEvent additional_info:text closed:boolean closed_by:integer closed_at:datetime user:belongs_to crisis_type:belongs_to 

 rails g model CrisisNote content:text crisis_event:belongs_to team_member:belongs_to 

 rails g controller CrisisTypes; rails g controller CrisisEvents; rails g controller CrisisNotes; 

 rails g model WellbeingMetric name:string type:string team_member:belongs_to 

 rails g model WbaSelf user:belongs_to 

 rails g model WbaSelfScore value:integer priority:integer wba_self:belongs_to wellbeing_metric:belongs_to 

 rails g model WbaSelfPermission wba_self:belongs_to team_member:belongs_to 

 rails g model WbaSelfViewLog wba_self:belongs_to team_member:belongs_to 

 rails g model WbaTeamMember team_member:belongs_to user:references 

 rails g model WbaTeamMemberScore value:integer priority:integer wba_team_member:belongs_to wellbeing_metric:belongs_to 

 rails g controller WellbeingMetrics; rails g controller WbaSelves; rails g controller WbaSelfScores; rails g controller WbaSelfPermissions; rails g controller WbaSelfViewLogs; rails g controller WbaTeamMembers; rails g controller WbaTeamMemberScores;
 
 rails db:create; rails db:migrate
 ```

Setup Repo
