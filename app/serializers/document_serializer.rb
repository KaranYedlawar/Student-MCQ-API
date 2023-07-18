class DocumentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :user_id, :interest_id, :qualification_id, :government_id, :cv, :college_name, :career_goals, :known_languages, :other_languages, :currently_working, :specialization, :total_experience, :availability

  attributes :cv do |resume|
    if resume.cv.present?
      host = Rails.env.development? ? "http://localhost:3000" : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(resume.cv,only_path: true)
    end
  end

  attributes :government_id do |government_doc|
    if government_doc.government_id.present?
      host = Rails.env.development? ? "http://localhost:3000" : ENV["BASE_URL"]
      host + Rails.application.routes.url_helpers.rails_blob_url(government_doc.government_id,only_path: true)
    end
  end

end
