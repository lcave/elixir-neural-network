defmodule Weights do
  def initialize_weights(input_node_count, hidden_node_count, output_node_count) do
    gen_random_normal = fn e -> e - 0.5 end

    input_to_hidden_weights =
      Matrex.random(hidden_node_count, input_node_count)
      |> Matrex.apply(gen_random_normal)

    hidden_to_output_weights =
      Matrex.random(output_node_count, hidden_node_count)
      |> Matrex.apply(gen_random_normal)

    {input_to_hidden_weights, hidden_to_output_weights}
  end

  def determine_input_node_count(training_data) do
    first_data_point = hd(training_data)

    input_matrix = elem(first_data_point, 2)
    input_node_count = input_matrix[:rows]
    IO.puts("#{input_node_count} input nodes required based on dataset")
    input_node_count
  end

  def determine_output_node_count(training_data) do
    first_data_point = hd(training_data)

    output_matrix = elem(first_data_point, 1)
    output_node_count = length(output_matrix)
    IO.puts("#{output_node_count} output nodes required based on dataset")
    output_node_count
  end

  def save_weights_to_disk(filename, weights) do
    case File.write(filename, "", [:write, :exclusive]) do
      :ok ->
        Matrex.save(weights, filename)

      {:error, :eexist} ->
        Matrex.save(weights, filename)

      {:error, reason} ->
        IO.puts("Error creating file #{filename}: #{reason}")
    end
  end
end
