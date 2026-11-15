package xiaozhi.modules.timbre.service;

import java.util.List;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.model.dto.VoiceDTO;
import xiaozhi.modules.timbre.dto.TimbreDataDTO;
import xiaozhi.modules.timbre.dto.TimbrePageDTO;
import xiaozhi.modules.timbre.entity.TimbreEntity;
import xiaozhi.modules.timbre.vo.TimbreDetailsVO;

/**
 * Timbre business layer definition
 * 
 * @author zjy
 * @since 2025-3-21
 */
public interface TimbreService extends BaseService<TimbreEntity> {
    /**
     * Get the timbres under the specified tts by page
     * 
     * @param dto pagination search parameters
     * @return paged timbre list data
     */
    PageData<TimbreDetailsVO> page(TimbrePageDTO dto);

    /**
     * Get the details of the timbre with the specified id
     * 
     * @param timbreId timbre table id
     * @return timbre information
     */
    TimbreDetailsVO get(String timbreId);

    /**
     * Save timbre information
     * 
     * @param dto data to save
     */
    void save(TimbreDataDTO dto);

    /**
     * Save timbre information
     * 
     * @param timbreId id to update
     * @param dto      data to update
     */
    void update(String timbreId, TimbreDataDTO dto);

    /**
     * Batch delete timbres
     * 
     * @param ids list of timbre ids to delete
     */
    void delete(String[] ids);

    List<VoiceDTO> getVoiceNames(String ttsModelId, String voiceName);

    /**
     * Get the first valid language of an ordinary timbre or cloned timbre configuration.
     *
     * @param id timbre ID
     * @return default language; null when the timbre does not exist or has no valid language configured
     */
    String getDefaultLanguageById(String id);

    /**
     * Get the timbre name by ID
     * 
     * @param id timbre ID
     * @return timbre name
     */
    String getTimbreNameById(String id);

    /**
     * Get timbre information by timbre code
     * 
     * @param ttsModelId timbre model ID
     * @param voiceCode  timbre code
     * @return timbre information
     */
    VoiceDTO getByVoiceCode(String ttsModelId, String voiceCode);
}
