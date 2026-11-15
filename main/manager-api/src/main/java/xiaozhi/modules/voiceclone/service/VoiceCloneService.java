package xiaozhi.modules.voiceclone.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.voiceclone.dto.VoiceCloneDTO;
import xiaozhi.modules.voiceclone.dto.VoiceCloneResponseDTO;
import xiaozhi.modules.voiceclone.entity.VoiceCloneEntity;

/**
 * Voice clone management
 */
public interface VoiceCloneService extends BaseService<VoiceCloneEntity> {

    /**
     * Query by page
     */
    PageData<VoiceCloneEntity> page(Map<String, Object> params);

    /**
     * Save voice clones
     */
    void save(VoiceCloneDTO dto);

    /**
     * Batch delete
     */
    void delete(String[] ids);

    /**
     * Query the voice clone list by user ID
     * 
     * @param userId user ID
     * @return voice clone list
     */
    List<VoiceCloneEntity> getByUserId(Long userId);

    /**
     * Query by page the voice clone list with model names and user names
     */
    PageData<VoiceCloneResponseDTO> pageWithNames(Map<String, Object> params);

    /**
     * Query by ID the voice clone information with model name and user name
     */
    VoiceCloneResponseDTO getByIdWithNames(String id);

    /**
     * Query by user ID the voice clone list with model names
     */
    List<VoiceCloneResponseDTO> getByUserIdWithNames(Long userId);

    /**
     * Upload an audio file
     */
    void uploadVoice(String id, MultipartFile voiceFile) throws Exception;

    /**
     * Update the voice clone name
     */
    void updateName(String id, String name);

    /**
     * Get the audio data
     */
    byte[] getVoiceData(String id);

    /**
     * Clone audio, calling Volcano Engine for voice replication training
     * 
     * @param cloneId voice clone record ID
     */
    void cloneAudio(String cloneId);
}
