package com.ssafy.dokcho2.service.minigame;

import com.ssafy.dokcho2.dto.minigame.WordsDto;

import java.util.List;

public interface WordsService {

    List<WordsDto> getProblem(Integer count);
}
