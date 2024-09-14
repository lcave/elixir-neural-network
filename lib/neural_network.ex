defmodule NeuralNetwork do
  def train do
    dataset = UserInput.select_dataset()

    IO.puts("Loading #{dataset}")
    training_data = CsvLoader.load("datasets/#{dataset}")
    IO.puts("#{length(training_data)} data points loaded")

    input_node_count = Weights.determine_input_node_count(training_data)
    output_node_count = Weights.determine_output_node_count(training_data)

    IO.puts("Enter hidden node count:")
    hidden_node_count = IO.gets("> ") |> String.trim() |> String.to_integer()

    IO.puts("Enter learning rate:")
    learning_rate = IO.gets("> ") |> String.trim() |> String.to_float()

    IO.puts("Commencing training")

    {input_to_hidden_weights, hidden_to_output_weights} =
      Weights.initialize_weights(input_node_count, hidden_node_count, output_node_count)

    {final_input_to_hidden_weights, final_hidden_to_output_weights} =
      Trainer.train(
        training_data,
        input_to_hidden_weights,
        hidden_to_output_weights,
        learning_rate
      )

    learning_rate_str = Float.to_string(learning_rate) |> String.replace(".", "_")

    input_to_hidden_weights_filename =
      "trained_weights/input_to_hidden_weights_#{dataset}_#{hidden_node_count}_#{learning_rate_str}.mtx"

    hidden_to_output_weights_filename =
      "trained_weights/hidden_to_output_weights_#{dataset}_#{hidden_node_count}_#{learning_rate_str}.mtx"

    IO.puts("Training complete, saving weights to")
    IO.puts(input_to_hidden_weights_filename)
    IO.puts(hidden_to_output_weights_filename)

    Weights.save_weights_to_disk(
      input_to_hidden_weights_filename,
      final_input_to_hidden_weights
    )

    Weights.save_weights_to_disk(
      hidden_to_output_weights_filename,
      final_hidden_to_output_weights
    )
  end

  def query(input, input_to_hidden_weights, hidden_to_output_weights) do
    hidden_inputs = Matrex.dot(input_to_hidden_weights, input)
    hidden_outputs = Matrex.apply(hidden_inputs, :sigmoid)

    final_inputs = Matrex.dot(hidden_to_output_weights, hidden_outputs)
    final_outputs = Matrex.apply(final_inputs, :sigmoid)

    final_outputs
  end

  def evaluate() do
    NeuralNetworkEvaluator.evaluate()
  end
end
