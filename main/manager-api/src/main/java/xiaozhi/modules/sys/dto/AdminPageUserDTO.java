package xiaozhi.modules.sys.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import lombok.Data;

/**
 * Parameter DTO for administrator paged users
 * 
 * @author zjy
 * @since 2025-3-21
 */
@Data
@Schema(description = "Parameter DTO for administrator paged users")
public class AdminPageUserDTO {

    @Schema(description = "Mobile number")
    private String mobile;

    @Schema(description = "Page number")
    @Min(value = 0, message = "{sort.number}")
    private String page;

    @Schema(description = "Number of rows shown")
    @Min(value = 0, message = "{sort.number}")
    private String limit;
}
