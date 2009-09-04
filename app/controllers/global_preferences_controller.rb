class GlobalPreferencesController < Astrails::AdminResourceController
  unloadable
  before_filter :require_admin

  create.wants.html {redirect_to collection_url}
  update.wants.html {redirect_to collection_url}
  destroy.wants.html {redirect_to collection_url}
end
