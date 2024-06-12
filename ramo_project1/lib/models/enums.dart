enum LoginStatus {
  notLoggedIn,
  developer,
  admin,
  customer,
}

enum ServiceCategory {
  web,
  mobile,
  uiux,
  architecture,
}

Map<ServiceCategory, String> categoriesAsString = {
  ServiceCategory.web: 'Web Programming',
  ServiceCategory.mobile: 'Mobile Programming',
  ServiceCategory.uiux: 'UI/UX',
  ServiceCategory.architecture: 'Architecture'
};

enum ServiceOrderLikeStatus {
  none,
  isLiked,
  isDisliked,
}
