
/*
App Module
 */
var BlogzingaApp, BlogzingaConfiguration;

BlogzingaApp = (function() {
  function BlogzingaApp() {
    return ['ui.router', 'templates', 'bloglist'];
  }

  return BlogzingaApp;

})();

BlogzingaConfiguration = (function() {
  function BlogzingaConfiguration($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) {
    if (!$httpProvider.defaults.headers.get) {
      $httpProvider.defaults.headers.get = {};
    }
    $httpProvider.defaults.headers.get['If-Modified-Since'] = '0';
    $locationProvider.html5Mode(false);
    $urlRouterProvider.otherwise('/blogzinga/list');
    $stateProvider.state('bloggers', {
      abstract: true,
      url: '/blogzinga',
      views: {
        'template': {
          templateUrl: 'components/home.html'
        }
      }
    });
  }

  return BlogzingaConfiguration;

})();

angular.module('blogzinga', new BlogzingaApp()).config(['$stateProvider', '$urlRouterProvider', '$locationProvider', '$httpProvider', BlogzingaConfiguration]);


/*
App Module
 */
var BlogList, BlogListApp, BlogListConfiguration, BlogListService, Join;

BlogListApp = (function() {
  function BlogListApp() {
    return ['ui.router', 'templates', 'ab-base64'];
  }

  return BlogListApp;

})();

BlogListConfiguration = (function() {
  function BlogListConfiguration($stateProvider) {
    $stateProvider.state('bloggers.list', {
      url: '/list',
      views: {
        '': {
          templateUrl: 'components/bloglist/list.html',
          controller: 'blogListController'
        }
      }
    });
  }

  return BlogListConfiguration;

})();

BlogList = (function() {
  function BlogList($scope, BlogListService, base64) {
    BlogListService.getBlogs().then(function(resp) {
      $scope.blogs = angular.fromJson(base64.decode(resp));
    });
  }

  return BlogList;

})();

BlogListService = (function() {
  function BlogListService($http) {
    return {
      getBlogs: function() {
        return $http.get('https://api.github.com/repos/cosenonjaviste/blogzinga/contents/blogs.json?ref=master').then(function(resp) {
          return resp.data.content;
        });
      }
    };
  }

  return BlogListService;

})();

Join = (function() {
  function Join() {
    return function(value) {
      return typeof value.join === "function" ? value.join(', ') : void 0;
    };
  }

  return Join;

})();

angular.module('bloglist', new BlogListApp()).config(['$stateProvider', BlogListConfiguration]).controller('blogListController', ['$scope', 'BlogListService', 'base64', BlogList]).factory('BlogListService', ['$http', BlogListService]).filter('join', [Join]);

//# sourceMappingURL=maps/app.js.map