#include <Python.h>
#include <usdex/core/Core.h>

static PyObject* version(PyObject*, PyObject*)
{
    return PyUnicode_FromString(usdex::core::version());
}

static PyMethodDef methods[] = {
    {"version", version, METH_NOARGS, nullptr},
    {nullptr, nullptr, 0, nullptr},
};
static PyModuleDef module = {
    PyModuleDef_HEAD_INIT, "consumer_plugin", nullptr, -1, methods,
};
PyMODINIT_FUNC PyInit_consumer_plugin()
{
    return PyModule_Create(&module);
}
