# StudyPortal

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Test for login/register/logout

```bash
curl --location 'http://localhost:4000/api/register' \
--header 'Content-Type: application/json' \
--data '{
    "user": {
        "enrollment_number": "23113111",
        "password": "password123",
        "name": "user",
        "arcus_id": "11111111"
    }
}'
```

```bash
curl --location 'http://localhost:4000/api/login' \
--header 'Content-Type: application/json' \
--header 'Content-Type: application/json' \
--data '{
    "enrollment_number": "23111111",
    "password": "password123"
}'
```

```bash
curl --location 'http://localhost:4000/api/protected' \
--header 'Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJTdHVkeVBvcnRhbCIsImV4cCI6MTczNzY4NDQxNSwiaWF0IjoxNzM1MjY1MjE1LCJpc3MiOiJTdHVkeVBvcnRhbCIsImp0aSI6ImI1MDRhZTJlLTEzNmEtNDNhNi1hZmRjLTFiMjYyMTAzOTA5YSIsIm5iZiI6MTczNTI2NTIxNCwic3ViIjoiVXNlcjoxIiwidHlwIjoiYWNjZXNzIn0.GIvRgWmzfi2Hi1uGG90YOz8yV6E2xric39eOEkEsntjKoPqpxqVfHGJFurfVdWYQbA-JK091UnsDkyfk-vghUQ' \
--header 'Content-Type: application/json'
```

```bash
curl --location --request POST 'http://localhost:4000/api/logout' \
--header 'Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJTdHVkeVBvcnRhbCIsImV4cCI6MTczNzY4NDQxNSwiaWF0IjoxNzM1MjY1MjE1LCJpc3MiOiJTdHVkeVBvcnRhbCIsImp0aSI6ImI1MDRhZTJlLTEzNmEtNDNhNi1hZmRjLTFiMjYyMTAzOTA5YSIsIm5iZiI6MTczNTI2NTIxNCwic3ViIjoiVXNlcjoxIiwidHlwIjoiYWNjZXNzIn0.GIvRgWmzfi2Hi1uGG90YOz8yV6E2xric39eOEkEsntjKoPqpxqVfHGJFurfVdWYQbA-JK091UnsDkyfk-vghUQ' \
--header 'Content-Type: application/json'
```
