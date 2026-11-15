import { getEnvBaseUrl } from './index'
import { toast } from './toast'

/**
 * Usage example of the file upload hook
 * @example
 * const { loading, error, data, progress, run } = useUpload<IUploadResult>(
 *   uploadUrl,
 *   {},
 *   {
 *     maxSize: 5, // Maximum 5MB
 *     sourceType: ['album'], // Only selection from the album is supported
 *     onProgress: (p) => console.log(`Upload progress: ${p}%`),
 *     onSuccess: (res) => console.log('Upload succeeded', res),
 *     onError: (err) => console.error('Upload failed', err),
 *   },
 * )
 */

/**
 * URL configuration for file uploads
 */
export const uploadFileUrl = {
  /** User avatar upload address (reads the currently effective BaseURL dynamically) */
  get USER_AVATAR() {
    return `${getEnvBaseUrl()}/user/avatar`
  },
}

/**
 * Generic file upload function (supports passing a file path directly)
 * @param url Upload address
 * @param filePath Local file path
 * @param formData Extra form data
 * @param options Upload options
 */
export function useFileUpload<T = string>(url: string, filePath: string, formData: Record<string, any> = {}, options: Omit<UploadOptions, 'sourceType' | 'sizeType' | 'count'> = {}) {
  return useUpload<T>(
    url,
    formData,
    {
      ...options,
      sourceType: ['album'],
      sizeType: ['original'],
    },
    filePath,
  )
}

export interface UploadOptions {
  /** Maximum number of images that can be selected, default 1 */
  count?: number
  /** Size of the selected images: original - original image, compressed - compressed image */
  sizeType?: Array<'original' | 'compressed'>
  /** Image source: album - album, camera - camera */
  sourceType?: Array<'album' | 'camera'>
  /** File size limit, unit: MB */
  maxSize?: number //
  /** Upload progress callback */
  onProgress?: (progress: number) => void
  /** Upload success callback */
  onSuccess?: (res: Record<string, any>) => void
  /** Upload failure callback */
  onError?: (err: Error | UniApp.GeneralCallbackResult) => void
  /** Upload complete callback (regardless of success or failure) */
  onComplete?: () => void
}

/**
 * File upload hook
 * @template T Type of the data returned after a successful upload
 * @param url Upload address
 * @param formData Extra form data
 * @param options Upload options
 * @returns Upload state and control object
 */
export function useUpload<T = string>(url: string, formData: Record<string, any> = {}, options: UploadOptions = {},
  /** Pass a file path directly, skipping the picker */
  directFilePath?: string) {
  /** Uploading state */
  const loading = ref(false)
  /** Upload error state */
  const error = ref(false)
  /** Response data after a successful upload */
  const data = ref<T>()
  /** Upload progress (0-100) */
  const progress = ref(0)

  /** Destructure upload options and set defaults */
  const {
    /** Maximum number of images that can be selected */
    count = 1,
    /** Size of the selected images */
    sizeType = ['original', 'compressed'],
    /** Image source */
    sourceType = ['album', 'camera'],
    /** File size limit (MB) */
    maxSize = 10,
    /** Progress callback */
    onProgress,
    /** Success callback */
    onSuccess,
    /** Failure callback */
    onError,
    /** Complete callback */
    onComplete,
  } = options

  /**
   * Check whether the file size exceeds the limit
   * @param size File size (bytes)
   * @returns Whether the check passed
   */
  const checkFileSize = (size: number) => {
    const sizeInMB = size / 1024 / 1024
    if (sizeInMB > maxSize) {
      toast.warning(`File size cannot exceed ${maxSize}MB`)
      return false
    }
    return true
  }
  /**
   * Trigger file selection and upload
   * Uses a different picker depending on the platform:
   * - WeChat Mini Program uses chooseMedia
   * - Other platforms use chooseImage
   */
  const run = () => {
    if (directFilePath) {
      // Use the passed-in file path directly
      loading.value = true
      progress.value = 0
      uploadFile<T>({
        url,
        tempFilePath: directFilePath,
        formData,
        data,
        error,
        loading,
        progress,
        onProgress,
        onSuccess,
        onError,
        onComplete,
      })
      return
    }

    // #ifdef MP-WEIXIN
    // Use the chooseMedia API in the WeChat Mini Program environment
    uni.chooseMedia({
      count,
      mediaType: ['image'], // Only image types are supported
      sourceType,
      success: (res) => {
        const file = res.tempFiles[0]
        // Check whether the file size is within the limit
        if (!checkFileSize(file.size))
          return

        // Start uploading
        loading.value = true
        progress.value = 0
        uploadFile<T>({
          url,
          tempFilePath: file.tempFilePath,
          formData,
          data,
          error,
          loading,
          progress,
          onProgress,
          onSuccess,
          onError,
          onComplete,
        })
      },
      fail: (err) => {
        console.error('Failed to select media file:', err)
        error.value = true
        onError?.(err)
      },
    })
    // #endif

    // #ifndef MP-WEIXIN
    // Use the chooseImage API outside the WeChat Mini Program environment
    uni.chooseImage({
      count,
      sizeType,
      sourceType,
      success: (res) => {
        console.log('Image selected:', res)

        // Start uploading
        loading.value = true
        progress.value = 0
        uploadFile<T>({
          url,
          tempFilePath: res.tempFilePaths[0],
          formData,
          data,
          error,
          loading,
          progress,
          onProgress,
          onSuccess,
          onError,
          onComplete,
        })
      },
      fail: (err) => {
        console.error('Failed to select image:', err)
        error.value = true
        onError?.(err)
      },
    })
    // #endif
  }

  return { loading, error, data, progress, run }
}

/**
 * File upload options interface
 * @template T Type of the data returned after a successful upload
 */
interface UploadFileOptions<T> {
  /** Upload address */
  url: string
  /** Temporary file path */
  tempFilePath: string
  /** Extra form data */
  formData: Record<string, any>
  /** Response data after a successful upload */
  data: Ref<T | undefined>
  /** Upload error state */
  error: Ref<boolean>
  /** Uploading state */
  loading: Ref<boolean>
  /** Upload progress (0-100) */
  progress: Ref<number>
  /** Upload progress callback */
  onProgress?: (progress: number) => void
  /** Upload success callback */
  onSuccess?: (res: Record<string, any>) => void
  /** Upload failure callback */
  onError?: (err: Error | UniApp.GeneralCallbackResult) => void
  /** Upload complete callback */
  onComplete?: () => void
}

/**
 * Perform the file upload
 * @template T Type of the data returned after a successful upload
 * @param options Upload options
 */
function uploadFile<T>({
  url,
  tempFilePath,
  formData,
  data,
  error,
  loading,
  progress,
  onProgress,
  onSuccess,
  onError,
  onComplete,
}: UploadFileOptions<T>) {
  try {
    // Create the upload task
    const uploadTask = uni.uploadFile({
      url,
      filePath: tempFilePath,
      name: 'file', // Key for the file
      formData,
      header: {
        // In the H5 environment Content-Type does not need to be set manually; let the browser handle the multipart format
        // #ifndef H5
        'Content-Type': 'multipart/form-data',
        // #endif
      },
      // Make sure the file name is valid
      success: (uploadFileRes) => {
        console.log('File uploaded:', uploadFileRes)
        try {
          // Parse the response data
          const { data: _data } = JSON.parse(uploadFileRes.data)
          // Upload succeeded
          data.value = _data as T
          onSuccess?.(_data)
        }
        catch (err) {
          // Response parse error
          console.error('Failed to parse upload response:', err)
          error.value = true
          onError?.(new Error('Failed to parse upload response'))
        }
      },
      fail: (err) => {
        // Upload request failed
        console.error('File upload failed:', err)
        error.value = true
        onError?.(err)
      },
      complete: () => {
        // Runs regardless of success or failure
        loading.value = false
        onComplete?.()
      },
    })

    // Listen for upload progress
    uploadTask.onProgressUpdate((res) => {
      progress.value = res.progress
      onProgress?.(res.progress)
    })
  }
  catch (err) {
    // Failed to create the upload task
    console.error('Failed to create upload task:', err)
    error.value = true
    loading.value = false
    onError?.(new Error('Failed to create upload task'))
  }
}
