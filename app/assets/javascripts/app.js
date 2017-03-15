"use-strict";

(function() {
    var app = angular.module("app", ['ui.router']);
    var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
    app.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
        $stateProvider
            .state('home', { url: "/", templateUrl: "/templates/home.html", controller: "homeCtrl" })
            .state('app', { url: "/a/:app", templateUrl: "/templates/app.html", controller: "appCtrl" });
        $urlRouterProvider.otherwise("/");
    }]);

    // Home controller for home page view
    app.controller("homeCtrl", ['$scope', '$http', function($scope, $http) {
        $http.get("/apps/get_apps").then(function(res) {
            $scope.u_apps = res.data;
        }, function(err) {});

        $scope.createApp = function(ua) {
            $http.post("/apps/create?authenticity_token=" + encodeURIComponent(AUTH_TOKEN), ua).then(function(res) {
                $scope.u_apps.push(res.data);
                $scope.ua = {};
            }, function(err) { $scope.ca_err_log = err; });
        }
    }]);

    // App controller for apps related functions
    app.controller("appCtrl", ['$scope', '$http', '$stateParams', function($scope, $http, $stateParams) {

        // Get basic app info and related data..        
        $http.get("/apps/get_app?id=" + $stateParams.app).then(function(res) {
            $scope.app = res.data;
            $scope.app.db_inf = JSON.parse($scope.app.db_inf);
            $http.get("/apps/get_ctrls").then(function(res) {
                $scope.ap_ctrls = res.data;
            }, function(err) {});

            $http.get("/apps/get_models").then(function(res) {
                $scope.ap_models = res.data;
            }, function(err) {});
        }, function(err) {});

        // Create data request..
        $scope.createD = function(alD, sd, act) {
            $http.post("/apps/" + act + "?authenticity_token=" + encodeURIComponent(AUTH_TOKEN), sd).then(function(res) {
                alD.push(res.data);
                sd = {};
            }, function(err) {});
        }

        // Update data request..
        $scope.updateD = function(sd, act) {
            if (sd.db_inf) {
                sd.db_inf = angular.toJson(sd.db_inf);
            }
            $http.post("/apps/" + act + "?authenticity_token=" + encodeURIComponent(AUTH_TOKEN), sd).then(function(res) {
                if (sd.db_inf) {
                    sd.db_inf = JSON.parse(sd.db_inf);
                }
            }, function(err) {});
        }

        $scope.selCtrl = function(ctrl) {
            $scope.selectedCtrl = ctrl;
        }

        $scope.selModel = function(mdl) {
            $scope.selectedModel = mdl;
        }

        $scope.selCtrlv = function(ctrl) {
            $scope.selectedCtrlv = ctrl;
            $http.get("/apps/get_views?ctrl_n=" + ctrl.name).then(function(res) {
                $scope.ctrl_views = res.data;
                $("#views_list").removeClass("hide");
                $("#ctrl_view").addClass('hide');
            }, function(err) {});
        }

        $scope.selView = function(view) {
            $scope.selectedView = view;
            $scope.selectedView.ctrl_n = $scope.selectedCtrlv.name;
            $("#views_list").addClass("hide");
            $("#ctrl_view").removeClass('hide');
        }
    }]);
}());
