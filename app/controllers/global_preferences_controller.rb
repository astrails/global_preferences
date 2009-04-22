class GlobalPreferencesController < ResourceController::Base
  #before_filter :require_admin
  new_action do
    before do
      @global_preference.ttl ||= GlobalPreference::DEFAULT_TTL
    end
  end
  create.wants.html {redirect_to collection_url}
  update.wants.html {redirect_to collection_url}
  destroy.wants.html {redirect_to collection_url}
end
