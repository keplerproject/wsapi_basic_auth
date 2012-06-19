
module("wsapi.basic_auth", package.seeall)

local request = require("wsapi.request")
local response = require("wsapi.response")
local base64 = require("base64")

--[[
   A "wrapper function" that provides HTTP basic authentication
   for WSAPI apps. Example:
   
   function run(wsapi_env)
     return wsapi.basic_auth.run(wsapi_env, "my site", function(wsapi_env)
       local user, pass = wsapi_env.basic_auth.user, wsapi_env.basic_auth.password
       ...
     end)
   end
   
   The wsapi_env received is extended with a "basic_auth" field, which
   is a table containing fields "user" and "password".
   
   Alternatively, a fourth argement may be given, with a function that
   performs the authentication check.

   function run(wsapi_env)
     return wsapi.basic_auth.run(wsapi_env, "my site", my_run, my_check_user_pass)
   end
   
   @param wsapi_env The WSAPI environment
   @param realm The HTTP authentication realm
   (displayed in the user-password box)
   @param run_fn The "run" function from your app
   @param check_fn An optional check function which receives the user,
   password and any additional arguments given to this function, so
   you can isolate the checking of credentials. If check_fn returns
   false or nil, a 403 Forbidden error will be returned.
   @return The same returns as the WSAPI run function, which are either
   the return of your run_fn function, or the usual result of res:finish()
   for a 401 or 403 error code.
]]
function run(wsapi_env, realm, run_fn, check_fn, ...)
   local req = request.new(wsapi_env)
   local http_authorization = req.env["HTTP_AUTHORIZATION"]
   if http_authorization then
      local scheme, credential = http_authorization:match("(%S+)%s(%S+)")
      if scheme and credential then
         local user, password = base64.decode(credential):match("(.*):(.*)")
         wsapi_env.basic_auth = { user = user, password = password }
         if check_fn then
            if check_fn(user, password, ...) then
               return run_fn(wsapi_env)
            else
               local res = response.new()
               res.status = 403
               return res:finish()
            end
         else
            return run_fn(wsapi_env)
         end
      end
   end
   local res = response.new()
   res.headers["WWW-Authenticate"] = "Basic realm="..realm
   res.status = 401
   return res:finish()
end

