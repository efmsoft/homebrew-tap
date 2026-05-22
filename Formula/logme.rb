class Logme < Formula
  desc "Lightweight C/C++ logging framework with channels, routing, and VT100 colors"
  homepage "https://github.com/efmsoft/logme"
  url "https://github.com/efmsoft/logme/archive/refs/tags/v2.4.17.tar.gz"
  sha256 "3d83423224ac33f768c6ed0ed8ecf2345b760629c58bbb7e5bea428e3bb49b94"
  license "Apache-2.0"

  head "https://github.com/efmsoft/logme.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    args = std_cmake_args + %W[
      -G Ninja
      -DLOGME_BUILD_STATIC=ON
      -DLOGME_BUILD_DYNAMIC=OFF
      -DLOGME_BUILD_EXAMPLES=OFF
      -DLOGME_BUILD_TESTS=OFF
      -DLOGME_BUILD_TOOLS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <logme/logme.h>
      int main()
      {
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-llogme", "-o", "test"
    system "./test"
  end
end
