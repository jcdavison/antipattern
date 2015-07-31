controllers = angular.module('App.controllers', [])

controllers.controller('appController', ($scope, $rootScope, $modal, User, CodeReview, Offer, $attrs) ->
  User.isAuthorized().then (response) ->
    if response.status == 200
      User.getCommunityMembers()
      $rootScope.$broadcast 'authorized-user'

  CodeReview.getAll().then () ->
    $scope.allCodeReviews = CodeReview.allCodeReviews

  $rootScope.values = [ {title: 'Good Karma', value: 0} ]

  $scope.showFaq = () ->
    modalInstance = $modal.open(
      templateUrl: 'faq.html'
      controller: 'genericModalCtrl'
      size: 'md'
    )
)

controllers.controller('codeReviewsCtrl', ($scope, $rootScope, $modal, $location, User, $attrs, CodeReview, $sanitize) ->
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

  $scope.editCodeReview = () ->
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

controllers.controller('showCodeReview', ($routeParams, $scope, $rootScope, $modal, $location, User, $attrs, CodeReview, $sanitize) ->
  CodeReview.get($attrs.codeReviewId).then (response) ->
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

  $scope.editCodeReview = () ->
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
          $scope.review || $scope.codeReview
    )

)
controllers.controller('deleteCodeReviewModal', ($scope, $rootScope, $modalInstance, $modal, CodeReview, codeReview) ->
  $scope.delete = () ->
    CodeReview.delete(codeReview).then (response) ->
      if response.status == 200
        $rootScope.$broadcast 'codeReviewDeleted', codeReview
        $modalInstance.dismiss('cancel')
        redirectIf()

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')

  redirectIf = () ->
    if window.location.pathname.match /code-reviews\/\d*/
      window.location.pathname = "/"
)

controllers.controller('createCodeReviewModal', ($scope, $rootScope, $modalInstance, $modal, CodeReview, User) ->
  $scope.codeReview = {}
  $scope.codeReview.value = $scope.values[0]
  $scope.communityMembers = User.communityMembers
  $scope.display = 'code-review-submit'
  $scope.submitted = false

  $scope.createCodeReview = () ->
    $scope.submitted = true
    CodeReview.create($scope.codeReview).then (response) ->
      if response.status == 200 
        $scope.summary = response.data.code_review.summary
        $rootScope.$broadcast 'render-html-from-detail'
        $scope.display = 'code-review-success'
      else
        $scope.display = 'code-review-error'

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel');
)

controllers.controller('createCodeReview', ($scope, $rootScope, $modal, User) ->
  $scope.requestCodeReview = () ->
    # if $rootScope.authorizedUser == true
    #   modalInstance = $modal.open(
    #     templateUrl: 'requestCodeReview.html'
    #     controller: 'createCodeReviewModal'
    #     size: 'lg'
    #   )
    # else
    #   modalInstance = $modal.open(
    #     templateUrl: 'pleaseLogin.html'
    #     controller: 'genericModalCtrl'
    #   )
)


controllers.controller('editCodeReviewModal', ($scope, $rootScope, $modalInstance, User, codeReview, CodeReview) -> 
  $scope.codeReview = codeReview
  $scope.values = $rootScope.values 

  $scope.values.forEach (ele, i) ->
    if ele.value == codeReview.value / 100
      $scope.codeReview.value = $scope.values[i].value

  $scope.editCodeReview = () ->
    CodeReview.update($scope.codeReview).then () ->
      $rootScope.$broadcast 'render-html-from-detail'
      $modalInstance.dismiss('cancel')

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')
)

controllers.controller('offerCodeReviewModal', ($rootScope, $scope, $modalInstance, codeReview, Offer) ->
  $scope.newOffer = {code_review_id: codeReview.id}

  $scope.values = $rootScope.values 
  $scope.display = 'offer-submit'
  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')
  $scope.codeReview = codeReview

  $scope.offerCodeReview = () ->
    $scope.display = 'submitting'
    Offer.submit($scope.newOffer).then (r) ->
      if r.status == 200
        $scope.display = 'offer-success'
        $rootScope.$broadcast 'offer-success'
      if r.status == 204
        $scope.display = 'offer-error'
)

controllers.controller('paymentCollectionCtrl', ($rootScope, $scope, Offer, offer, User, $modalInstance) ->
  $scope.offer = offer
  $scope.offerValue = (offer.value / 100)
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
    if User.hasStripeAccount == null && newState.match /deliver|accept/ && $scope.offer.value != 0
      modalInstance = $modal.open(
        templateUrl: 'pleaseCompleteProfile.html'
        controller: 'genericModalCtrl'
      )
    else
      Offer.updateOfferState(newState: newState, offer: $scope.offer).then (response) ->
        $scope.offer = response.data.offer

  $scope.setPmtCollectionDetails = () ->
    if User.hasStripeAccount == null
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
