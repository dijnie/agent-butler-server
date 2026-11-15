import type { Ref } from 'vue'

interface IUseRequestOptions<T> {
  /** Whether to run immediately */
  immediate?: boolean
  /** Initial data */
  initialData?: T
}

interface IUseRequestReturn<T> {
  loading: Ref<boolean>
  error: Ref<boolean | Error>
  data: Ref<T | undefined>
  run: () => Promise<T | undefined>
}

/**
 * useRequest is a customized request hook for handling asynchronous requests and responses.
 * @param func A function that performs an asynchronous request and returns a Promise containing the response data.
 * @param options An object containing request options {immediate, initialData}.
 * @param options.immediate Whether to run the request immediately, default false.
 * @param options.initialData Initial data, default undefined.
 * @returns An object {loading, error, data, run} containing the request loading state, error info, response data and a function to trigger the request manually.
 */
export default function useRequest<T>(
  func: () => Promise<IResData<T>>,
  options: IUseRequestOptions<T> = { immediate: false },
): IUseRequestReturn<T> {
  const loading = ref(false)
  const error = ref(false)
  const data = ref<T | undefined>(options.initialData) as Ref<T | undefined>
  const run = async () => {
    loading.value = true
    return func()
      .then((res) => {
        data.value = res.data
        error.value = false
        return data.value
      })
      .catch((err) => {
        error.value = err
        throw err
      })
      .finally(() => {
        loading.value = false
      })
  }

  options.immediate && run()
  return { loading, error, data, run }
}
