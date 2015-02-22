controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, $modal, User, ReviewRequest, Offer, $attrs, Wallet) ->
  User.isAuthorized().then (response) ->
    if response.success
      Wallet.hasValidToken().then () ->
        User.hasPmtToken = true
      $rootScope.$broadcast 'authorized-user'

  ReviewRequest.getAll().then () ->
    $scope.allCodeReviews = ReviewRequest.allCodeReviews

  $rootScope.values = [ {value: 10}, {value: 25}, {value: 50} ]
)

controllers.controller('userController', ($scope, $rootScope, $modal, User, ReviewRequest, Offer, $attrs, Wallet) ->

  $scope.$on 'authorized-user', () ->
    Wallet.hasValidToken().then () ->
      $scope.hasToken = true

  $scope.showForm = () ->
    $scope.hasToken = false
    $scope.submitted = false
)

controllers.controller('codeReviewsCtrl', ($scope, $rootScope, $modal, $location, User, $attrs, ReviewRequest, $sanitize) ->
  marked.setOptions(gfm: true)
  $scope.showDetail = false
  $scope.shouldHideOwnerTools = true

  renderHtml = () ->
    $scope.codeReviewHtml = marked($scope.review.detail)
  renderHtml()

  $scope.$on 'render-html-from-detail', () ->
    renderHtml()

  $scope.toggleDetail = () ->
    $scope.showDetail = ! $scope.showDetail

  $scope.editReviewRequest = () ->
    modalInstance = $modal.open(
      templateUrl: 'editCodeReview.html'
      controller: 'editCodeReviewModal'
      size: 'md'
      resolve:
        codeReview: () ->
          $scope.review
    )

  $scope.confirmReviewOffer = () ->
    if $rootScope.authorizedUser == true
      modalInstance = $modal.open(
        templateUrl: 'submitOffer.html'
        controller: 'offerCodeReviewModal'
        size: 'md'
        resolve:
          codeReview: () ->
            $scope.review
      )
    else
      modalInstance = $modal.open(
        templateUrl: 'pleaseLogin.html'
        controller: 'genericModalCtrl'
      )

  $scope.showDeleteModal = () ->
    modalInstance = $modal.open(
      templateUrl: 'deleteCodeReview.html'
      controller: 'deleteCodeReviewModal'
      size: 'md'
      resolve:
        codeReview: () ->
          $scope.review
    )
)

controllers.controller('showCodeReview', ($routeParams, $scope, $rootScope, $modal, $location, User, $attrs, ReviewRequest, $sanitize) ->
  ReviewRequest.get($attrs.reviewRequestId).then (response) ->
    $scope.codeReview = response.data.codeReview
    renderHtml()
  marked.setOptions(gfm: true)
  $scope.showDetail = false
  $scope.shouldHideOwnerTools = true

  renderHtml = () ->
    $scope.codeReviewHtml = marked($scope.codeReview.detail)

  $scope.$on 'render-html-from-detail', () ->
    renderHtml()

  $scope.toggleDetail = () ->
    $scope.showDetail = ! $scope.showDetail

  $scope.editReviewRequest = () ->
    modalInstance = $modal.open(
      templateUrl: 'editCodeReview.html'
      controller: 'editCodeReviewModal'
      size: 'md'
      resolve:
        codeReview: () ->
          $scope.codeReview
    )

  $scope.confirmReviewOffer = () ->
    if $rootScope.authorizedUser == true
      modalInstance = $modal.open(
        templateUrl: 'submitOffer.html'
        controller: 'offerCodeReviewModal'
        size: 'md'
        resolve:
          codeReview: () ->
            $scope.codeReview
      )
    else
      modalInstance = $modal.open(
        templateUrl: 'pleaseLogin.html'
        controller: 'genericModalCtrl'
      )

  $scope.showDeleteModal = () ->
    modalInstance = $modal.open(
      templateUrl: 'deleteCodeReview.html'
      controller: 'deleteCodeReviewModal'
      size: 'md'
      resolve:
        codeReview: () ->
          $scope.review
    )

)
controllers.controller('deleteCodeReviewModal', ($scope, $rootScope, $modalInstance, $modal, ReviewRequest, codeReview) ->
  $scope.delete = () ->
    ReviewRequest.delete(codeReview).then (response) ->
      if response.status == 200
        $rootScope.$broadcast 'codeReviewDeleted', codeReview
        $modalInstance.dismiss('cancel')

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')
)

controllers.controller('createCodeReviewModal', ($scope, $rootScope, $modalInstance, $modal, ReviewRequest) ->
  $scope.codeReview = {}
  $scope.values = $rootScope.values 
  $scope.codeReview.value = $scope.values[0]

  $scope.createReviewRequest = () ->
    ReviewRequest.create($scope.codeReview).then () ->
      $rootScope.$broadcast 'render-html-from-detail'
      $modalInstance.dismiss('cancel');

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

controllers.controller('createCodeReview', ($scope, $rootScope, $modal, User) ->
  $scope.requestCodeReview = () ->
    if $rootScope.authorizedUser == true
      modalInstance = $modal.open(
        templateUrl: 'requestCodeReview.html'
        controller: 'createCodeReviewModal'
      )
    else
      modalInstance = $modal.open(
        templateUrl: 'pleaseLogin.html'
        controller: 'genericModalCtrl'
      )
)


controllers.controller('editCodeReviewModal', ($scope, $rootScope, $modalInstance, User, codeReview, ReviewRequest) -> 
  $scope.codeReview = codeReview
  $scope.values = $rootScope.values 

  $scope.values.forEach (ele, i) ->
    if ele.value == codeReview.value / 100
      $scope.codeReview.value = $scope.values[i].value

  $scope.editReviewRequest = () ->
    ReviewRequest.update($scope.codeReview).then () ->
      $rootScope.$broadcast 'render-html-from-detail'
      $modalInstance.dismiss('cancel')

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')
)

controllers.controller('offerCodeReviewModal', ($rootScope, $scope, $modalInstance, codeReview, Offer) ->
  $scope.display = 'instructions'
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')

  $scope.offerCodeReview = () ->
    Offer.submit(codeReview.id).then (r) ->
      if r.status == 200
        $scope.display = 'offer-success'
        $rootScope.$broadcast 'offer-success'
      else
        $scope.display = 'offer-failure'
)

controllers.controller('paymentCollectionCtrl', ($rootScope, $scope, Offer, offer, User, $modalInstance) ->
  $scope.offer = offer
  $scope.offerValue = offer.code_review.display_value
  $scope.collect = $scope.offerValue
  $scope.fundACoder = 0
  $scope.proportionToDonate = 0

  $scope.slider =
    'options': 
      stop: (event, ui) ->
        percentToFund = percentage($scope.proportionToDonate)
        setValueToCollect(percentToFund)
        setValueToFund(percentToFund)
        $scope.$digest()

  $scope.setPaymentDetail = () ->
    $scope.detailsubmitted = true
    args = {}
    args.proportionToDonate = $scope.proportionToDonate 
    args.offer = $scope.offer
    Offer.setPaymentDetail(args).then (response) ->
      $scope.offer = response.data.offer
      $rootScope.$broadcast 'showpaid-true'
      $scope.cancel()

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');

  percentage = (proportion) ->
    proportion / 100

  setValueToCollect = (percentToFund) ->
    $scope.collect = roundToTwo( ( (1 - percentToFund) * $scope.offerValue))

  setValueToFund = (percentToFund) ->
    $scope.fundACoder = roundToTwo((percentToFund * $scope.offerValue))

  roundToTwo = (num) ->
    +(Math.round(num + "e+2") + "e-2")
)

controllers.controller('offerCtrl', ($rootScope, $scope, Offer, $attrs, User, $modal) ->
  $scope.acceptStatus = null

  $scope.$on 'showpaid-true', () ->
    $scope.offer.state = 'paid'
    $scope.showpaid = true

  $scope.updateOfferState = (newState) ->
    if User.hasPmtToken == null && newState.match /deliver|accept/
      modalInstance = $modal.open(
        templateUrl: 'pleaseCompleteProfile.html'
        controller: 'genericModalCtrl'
      )
    else
      Offer.updateOfferState( newState: newState, offer: $scope.offer).then (response) ->
        $scope.offer = response.data.offer

  $scope.setPmtCollectionDetails = () ->
    if User.hasPmtToken == null
      modalInstance = $modal.open(
        templateUrl: 'pleaseCompleteProfile.html'
        controller: 'genericModalCtrl'
      )
    else
      modalInstance = $modal.open(
        templateUrl: 'setPmtCollectionDetail.html'
        controller: 'paymentCollectionCtrl'
        resolve:
          offer: () ->
            $scope.offer
      )
  setAcceptStatus = () ->
    Offer.checkStatus($attrs.offerId).then (response) ->
      $scope.acceptStatus = Offer.accept_status

  $scope.$on 'authorized-user', () ->
    setAcceptStatus()
)

controllers.controller('genericModalCtrl', ($scope, $modalInstance) ->
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)
