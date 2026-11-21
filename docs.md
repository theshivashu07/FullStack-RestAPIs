

## step 1 : 
after creating project, go to create repository and run below commands t setup first ! 

```
echo "# FullStack-RestAPIs" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/theshivashu07/FullStack-RestAPIs.git
git push -u origin main
```


## step 2 : 
Know on which tech stack chooses which domain ? 

Frontend : Javascript and React.js ...
```localhost:8080```
Backend : Python and Django+DRF ...
```localhost:1234```
Database : Postgres under Docker ...
```localhost:5432```


## Ab endpoints ready hain:

Method     Endpoint
POST        .../api/v1/security/register/
POST        .../api/v1/security/login/
POST        .../api/v1/security/token/refresh/
POST        .../api/v1/security/logout/


### Hamare important URLs

Purpose	               Method       Endpoint
Home	                GET            /api/v1/home/
All users	            POST           /api/v1/users/
Current user	    POST           /api/v1/users/me/
Register	            POST          /api/v1/security/register/
Login	                 POST          /api/v1/security/login/
Refresh	                POST          /api/v1/security/token/refresh/
Logout	                POST          /api/v1/security/logout/



