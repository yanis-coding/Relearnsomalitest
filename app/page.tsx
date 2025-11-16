'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { BookOpen, MessageSquare, Trophy, Volume2, Mic, Send } from 'lucide-react'
import { Input } from '@/components/ui/input'
import { ScrollArea } from '@/components/ui/scroll-area'

export default function SomaliLearningApp() {
  const [activeTab, setActiveTab] = useState<'home' | 'reading' | 'speaking'>('home')
  const [progress, setProgress] = useState(35)
  const [chatMessages, setChatMessages] = useState<Array<{ role: 'user' | 'ai'; text: string }>>([
    { role: 'ai', text: 'Soo dhawoow! Maxaad jeclaan lahayd inaad ka hadalno maanta?' }
  ])
  const [inputMessage, setInputMessage] = useState('')

  const lessons = [
    { 
      id: 1, 
      title: 'Salaan iyo Is-aqoonsi', 
      description: 'Learn greetings and introductions',
      level: 'Beginner',
      completed: true
    },
    { 
      id: 2, 
      title: 'Qoyska', 
      description: 'Family members and relationships',
      level: 'Beginner',
      completed: true
    },
    { 
      id: 3, 
      title: 'Cuntada', 
      description: 'Food and dining vocabulary',
      level: 'Intermediate',
      completed: false
    },
    { 
      id: 4, 
      title: 'Safarka', 
      description: 'Travel and directions',
      level: 'Intermediate',
      completed: false
    }
  ]

  const handleSendMessage = () => {
    if (!inputMessage.trim()) return
    
    setChatMessages([...chatMessages, { role: 'user', text: inputMessage }])
    setInputMessage('')
    
    // Simulate AI response
    setTimeout(() => {
      setChatMessages(prev => [...prev, { 
        role: 'ai', 
        text: 'Waan ku fahmay! Waad ku fiicantahay luuqadda Soomaaliga.' 
      }])
    }, 1000)
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b border-border bg-card">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-primary-foreground" />
              </div>
              <div>
                <h1 className="text-2xl font-bold text-foreground">Relearn Somali</h1>
                <p className="text-sm text-muted-foreground">Master the Somali language</p>
              </div>
            </div>
            <div className="flex items-center gap-4">
              <div className="hidden md:flex items-center gap-2">
                <Trophy className="w-5 h-5 text-amber-500" />
                <span className="font-semibold text-foreground">1,250 XP</span>
              </div>
              <Button variant="outline" size="sm">Profile</Button>
            </div>
          </div>
        </div>
      </header>

      {/* Navigation */}
      <nav className="border-b border-border bg-card/50">
        <div className="container mx-auto px-4">
          <div className="flex gap-1">
            <button
              onClick={() => setActiveTab('home')}
              className={`px-6 py-3 text-sm font-medium transition-colors relative ${
                activeTab === 'home' 
                  ? 'text-primary' 
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              Home
              {activeTab === 'home' && (
                <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-primary" />
              )}
            </button>
            <button
              onClick={() => setActiveTab('reading')}
              className={`px-6 py-3 text-sm font-medium transition-colors relative ${
                activeTab === 'reading' 
                  ? 'text-primary' 
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              Reading Practice
              {activeTab === 'reading' && (
                <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-primary" />
              )}
            </button>
            <button
              onClick={() => setActiveTab('speaking')}
              className={`px-6 py-3 text-sm font-medium transition-colors relative ${
                activeTab === 'speaking' 
                  ? 'text-primary' 
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              AI Practice
              {activeTab === 'speaking' && (
                <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-primary" />
              )}
            </button>
          </div>
        </div>
      </nav>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        {activeTab === 'home' && (
          <div className="space-y-8">
            {/* Progress Card */}
            <Card className="bg-gradient-to-br from-primary/10 via-background to-background border-primary/20">
              <CardHeader>
                <CardTitle className="text-2xl">Your Learning Journey</CardTitle>
                <CardDescription>Keep up the great work!</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-muted-foreground">Overall Progress</span>
                    <span className="font-semibold text-foreground">{progress}%</span>
                  </div>
                  <Progress value={progress} className="h-3" />
                </div>
                <div className="grid grid-cols-3 gap-4 pt-4">
                  <div className="text-center">
                    <div className="text-2xl font-bold text-foreground">12</div>
                    <div className="text-xs text-muted-foreground">Lessons Completed</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-foreground">45</div>
                    <div className="text-xs text-muted-foreground">Day Streak</div>
                  </div>
                  <div className="text-center">
                    <div className="text-2xl font-bold text-foreground">8</div>
                    <div className="text-xs text-muted-foreground">Hours Practiced</div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Lessons Grid */}
            <div>
              <h2 className="text-xl font-bold mb-4 text-foreground">Your Lessons</h2>
              <div className="grid md:grid-cols-2 gap-4">
                {lessons.map((lesson) => (
                  <Card key={lesson.id} className="hover:border-primary/50 transition-colors">
                    <CardHeader>
                      <div className="flex items-start justify-between">
                        <div className="space-y-1">
                          <CardTitle className="text-lg">{lesson.title}</CardTitle>
                          <CardDescription>{lesson.description}</CardDescription>
                        </div>
                        {lesson.completed && (
                          <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center">
                            <Trophy className="w-4 h-4 text-primary" />
                          </div>
                        )}
                      </div>
                    </CardHeader>
                    <CardContent>
                      <div className="flex items-center justify-between">
                        <span className="text-xs px-2 py-1 rounded-full bg-secondary text-secondary-foreground">
                          {lesson.level}
                        </span>
                        <Button size="sm" variant={lesson.completed ? "outline" : "default"}>
                          {lesson.completed ? 'Review' : 'Start Lesson'}
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>
          </div>
        )}

        {activeTab === 'reading' && (
          <div className="max-w-3xl mx-auto space-y-6">
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-2xl">Qiso Yar - Short Story</CardTitle>
                    <CardDescription>Practice reading comprehension</CardDescription>
                  </div>
                  <Button variant="outline" size="icon">
                    <Volume2 className="w-4 h-4" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="prose prose-lg max-w-none">
                  <p className="text-lg leading-relaxed text-foreground">
                    <strong>Nabad gelyo!</strong> Magacaygu waa Ahmed. Waxaan degganahay magaalada Muqdisho. 
                    Waxaan ahay arday wax ku baranaya jaamacadda. Waxaan jeclahay in aan akhriyo buugaag 
                    iyo aan daawado filimyo. Qoyskayguna way wada wanaagsan yihiin.
                  </p>
                </div>
                
                <div className="bg-secondary/50 p-4 rounded-lg space-y-2">
                  <h3 className="font-semibold text-foreground">Translation</h3>
                  <p className="text-sm text-muted-foreground">
                    Hello! My name is Ahmed. I live in the city of Mogadishu. 
                    I am a student studying at the university. I love reading books 
                    and watching movies. My family is all well.
                  </p>
                </div>

                <div className="space-y-4">
                  <h3 className="font-semibold text-foreground">Comprehension Questions</h3>
                  <div className="space-y-3">
                    {[
                      'What is the person\'s name?',
                      'Where does Ahmed live?',
                      'What does Ahmed enjoy doing?'
                    ].map((question, idx) => (
                      <Card key={idx} className="bg-secondary/20">
                        <CardContent className="pt-6">
                          <p className="text-sm mb-3 text-foreground">{question}</p>
                          <Input placeholder="Type your answer..." />
                        </CardContent>
                      </Card>
                    ))}
                  </div>
                </div>

                <Button className="w-full">Submit Answers</Button>
              </CardContent>
            </Card>
          </div>
        )}

        {activeTab === 'speaking' && (
          <div className="max-w-3xl mx-auto">
            <Card className="h-[600px] flex flex-col">
              <CardHeader>
                <CardTitle className="text-2xl">Practice with AI Tutor</CardTitle>
                <CardDescription>
                  Have a conversation in Somali with our AI assistant
                </CardDescription>
              </CardHeader>
              <CardContent className="flex-1 flex flex-col">
                <ScrollArea className="flex-1 pr-4">
                  <div className="space-y-4">
                    {chatMessages.map((message, idx) => (
                      <div
                        key={idx}
                        className={`flex ${message.role === 'user' ? 'justify-end' : 'justify-start'}`}
                      >
                        <div
                          className={`max-w-[80%] rounded-lg px-4 py-3 ${
                            message.role === 'user'
                              ? 'bg-primary text-primary-foreground'
                              : 'bg-secondary text-secondary-foreground'
                          }`}
                        >
                          <p className="text-sm">{message.text}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </ScrollArea>

                <div className="mt-4 space-y-3">
                  <div className="flex gap-2">
                    <Button variant="outline" size="icon" className="shrink-0">
                      <Mic className="w-4 h-4" />
                    </Button>
                    <Input
                      placeholder="Type in Somali or English..."
                      value={inputMessage}
                      onChange={(e) => setInputMessage(e.target.value)}
                      onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()}
                    />
                    <Button size="icon" onClick={handleSendMessage} className="shrink-0">
                      <Send className="w-4 h-4" />
                    </Button>
                  </div>
                  <p className="text-xs text-center text-muted-foreground">
                    Click the microphone to practice speaking or type to chat
                  </p>
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </main>
    </div>
  )
}
