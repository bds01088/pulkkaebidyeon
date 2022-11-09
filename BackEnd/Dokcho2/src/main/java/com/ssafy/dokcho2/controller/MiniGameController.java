package com.ssafy.dokcho2.controller;

import com.ssafy.dokcho2.dto.minigame.WordsDto;
import com.ssafy.dokcho2.service.minigame.WordsService;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/game")
public class MiniGameController {

    private final WordsService wordsService;

    @GetMapping("/words/{count}")
    @ApiOperation(value = "사자성어 문제 리스트 받기")
    public ResponseEntity<List<WordsDto>> getProblem(@PathVariable Integer count){
        return new ResponseEntity<>(wordsService.getProblem(count), HttpStatus.OK);
    }
}
