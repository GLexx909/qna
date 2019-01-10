class GitHubClient

  def initialize
    @http_client = setup_http_client
  end

  def get_single_gist(gist_id)
    @http_client.get("gists/#{gist_id}")
  end

  private

  def setup_http_client
    Octokit::Client.new
  end
end
