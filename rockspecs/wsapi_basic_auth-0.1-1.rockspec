package = "WSAPI-Basic_Auth"
version = "0.1-1"

source = {
   url = "",
}

description = {
  summary =  "HTTP Basic Authentication for WSAPI",

  detailed = [[
     A module implemented HTTP basic access authentication for WSAPI.
     This provides a run() function that wraps around the run() function
     for your WSAPI handler.
  ]],
  license = "MIT/X11",
}

dependencies = {
   "wsapi",
   "base64",
}

build = {
   type = "builtin",
   modules = {
      ["wsapi.basic_auth"] = "wsapi/basic_auth.lua",
   },
}
