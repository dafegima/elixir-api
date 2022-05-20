defmodule RestApi.UseCases.UserQueryUseCase do
  alias RestApi.Repository.UserRepository

  def query_user(identification) do
    user = UserRepository.query_mongo_db(identification)
    if (user != nil) do
      transform(user)
    end
  end

  def add_user(user) do
    UserRepository.add_user(user)
  end

  def delete_user(identification) do
    UserRepository.delete_user(identification)
  end

  defp transform(item) do
    map = map_keys_to_atoms(item)

    %RestApi.Model.User{} = %RestApi.Model.User{
      identification: map[:identification],
      firtsName: map[:firtsName],
      lastName: map[:lastName],
      age: map[:age],
      nickName: map[:nickName]
    }
  end

  defp map_keys_to_atoms(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

end
