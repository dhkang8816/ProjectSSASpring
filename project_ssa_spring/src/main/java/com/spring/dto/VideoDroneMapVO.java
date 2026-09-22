package com.spring.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VideoDroneMapVO {
    private String sourceKey;
    private String droneId;
}
