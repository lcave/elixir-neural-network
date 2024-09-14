defmodule NeuralNetworkEvaluator do
  def evaluate do
    UserInput.select_weights()
    |> evaluate()
  end

  def evaluate({input_to_hidden_weights, hidden_to_output_weights}) do
    IO.puts("Testing the network:")
    test_data = CsvLoader.load("datasets/mnist_test.csv")

    {correct_count, incorrect_count} =
      evaluate(test_data, input_to_hidden_weights, hidden_to_output_weights, 0, 0)

    IO.puts("Correct: #{correct_count}, Incorrect: #{incorrect_count}")
    IO.puts("Accuracy: #{correct_count / (correct_count + incorrect_count) * 100}%")
  end

  defp evaluate(
         [head | tail],
         input_to_hidden_weights,
         hidden_to_output_weights,
         correct_count,
         incorrect_count
       ) do
    {actual_digit, _target_output, input} = head
    final_outputs = NeuralNetwork.query(input, input_to_hidden_weights, hidden_to_output_weights)

    {_max_value, max_index} =
      final_outputs
      |> Enum.with_index()
      |> Enum.max_by(fn {value, _index} -> value end)

    new_correct_count =
      if actual_digit == max_index, do: correct_count + 1, else: correct_count

    new_incorrect_count =
      if actual_digit != max_index, do: incorrect_count + 1, else: incorrect_count

    evaluate(
      tail,
      input_to_hidden_weights,
      hidden_to_output_weights,
      new_correct_count,
      new_incorrect_count
    )
  end

  defp evaluate(
         [],
         _input_to_hidden_weights,
         _hidden_to_output_weights,
         correct_count,
         incorrect_count
       ) do
    {correct_count, incorrect_count}
  end
end
