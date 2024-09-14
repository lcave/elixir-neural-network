defmodule UserInput do
  def select_dataset do
    IO.puts("Select dataset: ")

    print_option = fn {file, index} ->
      IO.puts("#{index}. #{file}")
    end

    {:ok, files} = File.ls("datasets")

    files
    |> Enum.with_index(1)
    |> Enum.each(print_option)

    dataset_index =
      IO.gets("> ")
      |> String.trim()
      |> String.to_integer()
      |> Kernel.-(1)

    Enum.at(files, dataset_index)
  end

  def select_weights do
    IO.puts("Select weights: ")

    print_option = fn {file, index} ->
      IO.puts("#{index}. #{file}")
    end

    {:ok, files} = File.ls("trained_weights")

    weight_options =
      files
      |> Enum.map(fn file -> String.split(file, "_weights_", parts: 2) |> Enum.at(1) end)
      |> Enum.uniq()
      |> Enum.sort()

    weight_options
    |> Enum.with_index(1)
    |> Enum.each(print_option)

    weight_option_index =
      IO.gets("> ")
      |> String.trim()
      |> String.to_integer()
      |> Kernel.-(1)

    selected_weights = Enum.at(weight_options, weight_option_index)

    input_to_hidden_weights =
      Matrex.load("trained_weights/input_to_hidden_weights_#{selected_weights}")

    hidden_to_output_weights =
      Matrex.load("trained_weights/hidden_to_output_weights_#{selected_weights}")

    IO.puts("Weights loaded")

    {input_to_hidden_weights, hidden_to_output_weights}
  end
end
