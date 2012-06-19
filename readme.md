
# wsapi.basic_auth

A "wrapper function" that provides HTTP basic authentication
for WSAPI apps. Example:

```
function run(wsapi_env)
  return wsapi.basic_auth.run(wsapi_env, "my site", function(wsapi_env)
    local user, pass = wsapi_env.basic_auth.user, wsapi_env.basic_auth.password
    ...
  end)
end
```

The wsapi_env received is extended with a "basic_auth" field, which
is a table containing fields "user" and "password".

Alternatively, a fourth argement may be given, with a function that
performs the authentication check.

```
function run(wsapi_env)
  return wsapi.basic_auth.run(wsapi_env, "my site", my_run, my_check_user_pass)
end
```

