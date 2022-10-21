package com.ssafy.dokcho2.service.item;

import com.ssafy.dokcho2.dto.item.ItemDto;

import java.util.List;

public interface ItemService {
    List<ItemDto> getItemList();

    List<ItemDto> addItem(Long itemId);

    List<ItemDto> useItem(Long itemId);
}
