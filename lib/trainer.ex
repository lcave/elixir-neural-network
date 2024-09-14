defmodule Trainer do
  def train(
        [head | tail],
        input_to_hidden_weights,
        hidden_to_output_weights,
        learning_rate
      ) do
    IO.puts("0.0%")

    train(
      [head | tail],
      input_to_hidden_weights,
      hidden_to_output_weights,
      learning_rate,
      length([head | tail])
    )
  end

  def train(
        [head | tail],
        input_to_hidden_weights,
        hidden_to_output_weights,
        learning_rate,
        initial_size
      ) do
    IO.write("\e[A")

    IO.puts(
      "#{((initial_size - length([head | tail])) / initial_size * 100) |> Float.round(1)}%  "
    )

    {_actual_digit, target_list, input} = head

    target =
      Matrex.new([target_list])
      |> Matrex.transpose()

    hidden_inputs = Matrex.dot(input_to_hidden_weights, input)
    hidden_outputs = Matrex.apply(hidden_inputs, :sigmoid)

    final_inputs = Matrex.dot(hidden_to_output_weights, hidden_outputs)
    final_outputs = Matrex.apply(final_inputs, :sigmoid)

    output_errors =
      Matrex.subtract(target, final_outputs)

    hidden_errors =
      Matrex.transpose(hidden_to_output_weights)
      |> Matrex.dot(output_errors)

    adjusted_hidden_to_output_weights =
      Matrex.multiply(output_errors, final_outputs)
      |> Matrex.multiply(Matrex.apply(final_outputs, fn x -> 1 - x end))
      |> Matrex.dot(Matrex.transpose(hidden_outputs))
      |> Matrex.apply(fn x -> x * learning_rate end)
      |> Matrex.add(hidden_to_output_weights)

    adjusted_input_to_hidden_weights =
      Matrex.multiply(hidden_errors, hidden_outputs)
      |> Matrex.multiply(Matrex.apply(hidden_outputs, fn x -> 1 - x end))
      |> Matrex.dot(Matrex.transpose(input))
      |> Matrex.apply(fn x -> x * learning_rate end)
      |> Matrex.add(input_to_hidden_weights)

    train(
      tail,
      adjusted_input_to_hidden_weights,
      adjusted_hidden_to_output_weights,
      learning_rate,
      initial_size
    )
  end

  def train(
        [],
        input_to_hidden_weights,
        hidden_to_output_weights,
        _learning_rate,
        _initial_size
      ) do
    {input_to_hidden_weights, hidden_to_output_weights}
  end
end
