This docker-compose file is to start a hosted gitlab with a runner

- docker network create proxy_default
- docker volume create gitlab-data
- docker volume create gitlab-log
- docker volume create gitlab-config
- docker volume create runner_config
- docker-compose up --build

Go to change the password here [gitlab docs](https://docs.gitlab.com/ee/security/reset_user_password.html#reset-your-root-password) in rails section