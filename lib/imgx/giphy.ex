defmodule Imgx.Giphy do
  use HTTPoison.Base

  def search(term, options \\ []) do
    query = 
      [q: term] ++ options
      |> URI.encode_query
    get!("/gifs/search?#{query}")
    |> process_response
  end

  def translate(term, options \\ []) do
    query = 
      [s: term] ++ options
      |> URI.encode_query
    get!("/gifs/translate?#{query}")
    |> process_response
  end

  def random(options \\ []) do
    query =
      options
      |> URI.encode_query
    get!("/gifs/random?#{query}")
    |> process_response
  end

  def process_url(url) do
    "https://api.giphy.com/v1" <> url
  end

  def process_response(%HTTPoison.Response{body: body, status_code: 200}), do: Poison.decode!(body)
end
