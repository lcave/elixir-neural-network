defmodule CsvLoader do
  def load(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.map(fn row ->
      {actual_digit, _} =
        hd(row)
        |> Integer.parse()

      target_output =
        List.duplicate(0.01, 10)
        |> List.replace_at(actual_digit, 0.99)

      handwriting_pixels =
        tl(row)
        |> Enum.map(&parse_and_scale_pixel/1)
        |> Enum.chunk_every(1)

      {actual_digit, target_output, Matrex.new(handwriting_pixels)}
    end)
  end

  defp parse_and_scale_pixel(pixel_string) do
    pixel = String.to_integer(pixel_string)
    pixel / 255 * 0.99 + 0.01
  end
end
