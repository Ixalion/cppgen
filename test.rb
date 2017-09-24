require "classcreate"

function_options = {
  type: "void",
  name: "myCoolFunction",
  params: [
    {
      type: "int",
      Name: "intparam",
    },
    {
      type: "float *",
      Name: "float_p",
      default: "nullptr",
    },
    {
      type: "long double",
      Name: "double_big",
      default: 0.234,
    }
  ],
  build_doxygen: true
}

classcreate_options = {
  name: "MyClass"
  namespace: ["ix", "test", "bahh"]
  use_struct: true,
  parents: [
    {
      scope: "private",
      name: "MyOtherClass"
    },
    {
      name: "MyParentClass"
    }
  ],
  private: {
    fields: [
      {
        type: "int",
        name: "my_int"
      },
      {
        type: "float",
        name: "MY_FLOAT"
      }
    ]
  },
  public: {
    fields: [
      {
        type: "int",
        name: "my_other_int"
      }
    ],
    functions: [
      function_options
    ]
  },
  project_includes: ["iostream"]
  system_includes: ["myfile.hpp", "myother_file.hpp"]
}
