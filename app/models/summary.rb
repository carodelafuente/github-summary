class Summary < ApplicationRecord
  validates :username, uniqueness: true
  GITHUB_API_URL="https://api.github.com"

  def ready?
    repos_response.present?
  end

  def user
    user_response
  end

  def repos
    repos_response.sort do |a, b|
      b["pushed_at"].to_date <=> a["pushed_at"].to_date

    end
  end

  def languages
    repos
      .map { |repo| repo["language"] }
      .reject { |lang| lang.blank? }
      .uniq
      .sort
      .join(", ")
  end

  def get_user
    url = "#{GITHUB_API_URL}/users/#{username}"
    self.user_response = authenticated_get(url)
  end

  def get_repos
    url = "#{GITHUB_API_URL}/users/#{username}/repos"
    response = authenticated_get(url)
    self.repos_response = response.to_a
  end

  def access_token
    "?access_token=#{ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]}"
  end

  def authenticated_get(url)
    HTTParty.get(url, headers: {
      authorization: "token #{ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]}",
      "User-Agent": "carodelafuente"
      })
  end
end
