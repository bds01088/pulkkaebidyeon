package com.ssafy.dokcho2.service.minigame;

import com.ssafy.dokcho2.domain.minigame.WordsRepository;
import com.ssafy.dokcho2.dto.minigame.WordsDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class WordsServiceImpl implements WordsService{

    private final WordsRepository wordsRepository;


    @Override
    public List<WordsDto> getProblem(Integer count) {
        return wordsRepository.findWordsRandom(count).stream().map(w -> WordsDto.from(w)).collect(Collectors.toList());
    }
}
