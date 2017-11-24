const defineSupportCode = require("cucumber").defineSupportCode;

let exec = require("child_process").exec;
let fs   = require("fs");

let openshift_password = process.env.OPENSHIFT_PASSWORD || "developer";
let openshift_url      = process.env.OPENSHIFT_URL      || "https://127.0.0.1:8443";
let build_id           = process.env.BUILD_NUMBER       || "1";
let build_name         = process.env.JOB_NAME           || "cucumber";

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

defineSupportCode(function({Before, After, Given, When, Then}){
  let memento  = {};
  let workdir  = "/tmp/" + build_name + "-" + build_id;
  let exec_opt = {};

  Before(function(){
    if(!fs.existsSync(workdir)){
      fs.mkdirSync(workdir);
    }

    exec_opt["env"]      = JSON.parse(JSON.stringify(process.env));
    exec_opt.env["HOME"] = workdir;
  });

  Given('I am logged in Openshift as {string}', function (username, callback) {
    exec("oc login --insecure-skip-tls-verify -u '" + username + "' -p '" + openshift_password + "' '" + openshift_url + "' ", exec_opt, function(error, stdout, stderr){
      if(error){
        callback(error);
      } else {
        callback();
      }
    });
  });

  Given('access to {string} namespace', function (namespace, callback) {
    exec("oc project " + namespace, exec_opt, function(error, stdout, stderr){
      if(error){
        callback(error);
      } else {
	callback();
      }
    });
  });

  When('query the pods of {string} replication controller', function (rc, callback) {
    exec("oc get pods -l app=" + rc + " -o json", exec_opt, function(error, stdout, stderr){
      if(error){
        callback(error);
      } else {
        memento[rc] = JSON.parse(stdout);
        callback();
      }
    });
  });

  Then('all pods managed by {string} replication controller should have the status equals to {string}', function (rc, podstatus, callback) {
    let pods = memento[rc];
    let errors = [];
    pods.items.forEach(function(pod){
      if(pod.status.phase.toLowerCase() !== podstatus.toLowerCase()){
        errors.push({
	  pod   : pod.metadata.name,
          status: pod.status.phase
        });
      }
    });

    if(errors.length !== 0){
      callback(new Error(JSON.stringify(errors)));
    } else {
      callback();
    }
  });
});
