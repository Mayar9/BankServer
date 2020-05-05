{application, bankServerApplication,
 [{description, ""},
  {vsn, "1.0.0"},
  {modules, [bankSupervisor,bankServerApplication,bankServer]},
  {registered, [bankServerApplication]},
  {applications, [kernel, stdlib]},
  {mod, {bankServerApplication, []}},
  {env, [{my_env1, "application example"},{bNameArg, "iti"}]}]}.