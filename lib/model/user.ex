defmodule RestApi.Model.User do
  @enforce_keys ~w[
    identification
    firtsName
    lastName
    age
    nickName]a

  defstruct ~w[
    identification
    firtsName
    lastName
    age
    nickName]a
end
