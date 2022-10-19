package com.ssafy.dokcho2.domain.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum ItemType {
    STORY_ITEM, PROVISO_ITEM, USE_ITEM;

    @JsonCreator
    public static ItemType from(String value) {
        return ItemType.valueOf(value.toUpperCase());
    }
}
