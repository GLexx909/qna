class GistGetService

  def initialize(client: default_client)
    @client = client
  end

  def call(gist_id)
    @client.get_single_gist(gist_id)
  end

  def default_client
    GitHubClient.new
  end
end
