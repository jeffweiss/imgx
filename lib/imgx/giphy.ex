defmodule Imgx.Giphy do
  use HTTPoison.Base

  def search(term, options \\ []) do
    request("/gifs/search", [q: term] ++ options)
  end

  def translate(term, options \\ []) do
    request("/gifs/translate", [s: term] ++ options)
  end

  def random(options \\ []) do
    request("/gifs/random", options)
  end

  defp request(uri, params) do
    get!(uri <> "?" <> URI.encode_query(params))
    |> process_response
  end

  def process_url(url) do
    "https://api.giphy.com/v1" <> url
  end

  def process_response(%HTTPoison.Response{body: body, status_code: 200}), do: Poison.decode!(body)
end
