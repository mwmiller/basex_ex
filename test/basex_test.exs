defmodule BaseXTest do
  use PowerAssert
  doctest BaseX

  test "encode/decode examples" do
    BaseX.prepare_module("Base10", "0123456789", 2)

    assert BaseX.Base10.encode(<<0,255>>) == "00255"
    assert BaseX.Base10.decode("00255")   == <<0,255>>
    assert BaseX.Base10.encode(<<0,255,0>>) == "00255000"
    assert BaseX.Base10.decode("00255000")   == <<0,255,0>>
    assert_raise RuntimeError, "Invalid input block: value too large", fn -> BaseX.Base10.decode("70000") end
    assert_raise RuntimeError, "Invalid input block: 0000", fn -> BaseX.Base10.decode("0000") end
  end

  test "base 62" do
    BaseX.prepare_module("Base62", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", 32)

    assert BaseX.Base62.encode("some random text") == "3Vp2TszAKnurweInsegL5w"
    assert BaseX.Base62.decode("3Vp2TszAKnurweInsegL5w") == "some random text"

    lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

  assert lorem |> BaseX.Base62.encode |> BaseX.Base62.decode == lorem, "lorem round-trip"

  end

end
